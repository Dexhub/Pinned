import CloudKit
import SwiftUI
import Combine

class CloudKitManager: ObservableObject {
    static let shared = CloudKitManager()
    
    @Published var iCloudAvailable = false
    @Published var syncStatus: SyncStatus = .idle
    @Published var lastSyncDate: Date?
    @AppStorage("iCloudSyncEnabled") var iCloudSyncEnabled = true
    
    private let container = CKContainer(identifier: "iCloud.com.aethon.pinned")
    private let privateDatabase: CKDatabase
    private var syncTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    enum SyncStatus {
        case idle
        case syncing
        case success
        case error(String)
        
        var description: String {
            switch self {
            case .idle: return "Ready to sync"
            case .syncing: return "Syncing..."
            case .success: return "Synced successfully"
            case .error(let message): return "Sync error: \(message)"
            }
        }
        
        var icon: String {
            switch self {
            case .idle: return "icloud"
            case .syncing: return "arrow.triangle.2.circlepath"
            case .success: return "checkmark.icloud"
            case .error: return "exclamationmark.icloud"
            }
        }
    }
    
    private init() {
        privateDatabase = container.privateCloudDatabase
        checkiCloudAvailability()
        setupAutoSync()
    }
    
    // MARK: - iCloud Availability
    
    private func checkiCloudAvailability() {
        container.accountStatus { [weak self] status, error in
            DispatchQueue.main.async {
                switch status {
                case .available:
                    self?.iCloudAvailable = true
                case .noAccount:
                    self?.iCloudAvailable = false
                    self?.syncStatus = .error("No iCloud account")
                case .restricted:
                    self?.iCloudAvailable = false
                    self?.syncStatus = .error("iCloud restricted")
                case .couldNotDetermine:
                    self?.iCloudAvailable = false
                    self?.syncStatus = .error("Could not determine iCloud status")
                default:
                    self?.iCloudAvailable = false
                }
            }
        }
    }
    
    // MARK: - Auto Sync
    
    private func setupAutoSync() {
        // Sync every 5 minutes when app is active
        syncTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            Task {
                await self?.syncIfNeeded()
            }
        }
        
        // Sync on app becoming active
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                Task {
                    await self?.syncIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
    
    private func syncIfNeeded() async {
        guard iCloudAvailable && iCloudSyncEnabled else { return }
        await sync()
    }
    
    // MARK: - Sync Operations
    
    @MainActor
    func sync() async {
        guard iCloudAvailable else {
            syncStatus = .error("iCloud not available")
            return
        }
        
        syncStatus = .syncing
        
        do {
            // Upload local changes
            try await uploadLocalData()
            
            // Download remote changes
            try await downloadRemoteData()
            
            // Merge conflicts
            try await mergeConflicts()
            
            syncStatus = .success
            lastSyncDate = Date()
            
            // Play success haptic
            HapticManager.shared.playSuccess()
            
        } catch {
            syncStatus = .error(error.localizedDescription)
            HapticManager.shared.playError()
        }
    }
    
    // MARK: - Upload Data
    
    private func uploadLocalData() async throws {
        let travelData = TravelData()
        
        // Create or update user record
        let userRecord = CKRecord(recordType: "User")
        userRecord["userName"] = travelData.userName
        userRecord["hasCompletedOnboarding"] = travelData.hasCompletedOnboarding
        userRecord["hasCompletedQuiz"] = travelData.hasCompletedQuiz
        userRecord["travelArchetype"] = travelData.travelArchetype?.rawValue
        userRecord["lastModified"] = Date()
        
        try await privateDatabase.save(userRecord)
        
        // Upload travel records
        for record in travelData.travelRecords {
            let ckRecord = CKRecord(recordType: "TravelRecord", recordID: CKRecord.ID(recordName: record.id.uuidString))
            ckRecord["placeType"] = record.placeType.rawValue
            ckRecord["name"] = record.name
            ckRecord["country"] = record.country
            ckRecord["continent"] = record.continent
            ckRecord["latitude"] = record.coordinates.latitude
            ckRecord["longitude"] = record.coordinates.longitude
            ckRecord["visitDate"] = record.visitDate
            ckRecord["endDate"] = record.endDate
            ckRecord["rating"] = record.rating
            ckRecord["tripType"] = record.tripType.rawValue
            ckRecord["companions"] = record.companions
            ckRecord["budget"] = record.budget ?? 0
            ckRecord["notes"] = record.notes
            ckRecord["weather"] = record.weather?.rawValue
            ckRecord["activities"] = record.activities.map { $0.rawValue }
            ckRecord["accommodation"] = record.accommodation
            ckRecord["highlights"] = record.highlights
            ckRecord["wouldRevisit"] = record.wouldRevisit
            ckRecord["tags"] = record.tags
            ckRecord["lastModified"] = Date()
            
            try await privateDatabase.save(ckRecord)
        }
    }
    
    // MARK: - Download Data
    
    private func downloadRemoteData() async throws {
        let travelData = TravelData()
        
        // Fetch user record
        let userQuery = CKQuery(recordType: "User", predicate: NSPredicate(value: true))
        let userResults = try await privateDatabase.records(matching: userQuery)
        
        if let userRecord = userResults.matchResults.first?.0.1 {
            // Update local user data if remote is newer
            if let remoteModified = userRecord["lastModified"] as? Date,
               let localModified = UserDefaults.standard.object(forKey: "lastModified") as? Date,
               remoteModified > localModified {
                
                travelData.userName = userRecord["userName"] as? String ?? ""
                travelData.hasCompletedOnboarding = userRecord["hasCompletedOnboarding"] as? Bool ?? false
                travelData.hasCompletedQuiz = userRecord["hasCompletedQuiz"] as? Bool ?? false
                
                if let archetypeRaw = userRecord["travelArchetype"] as? String {
                    travelData.travelArchetype = TravelArchetype(rawValue: archetypeRaw)
                }
                
                travelData.saveData()
            }
        }
        
        // Fetch travel records
        let recordQuery = CKQuery(recordType: "TravelRecord", predicate: NSPredicate(value: true))
        let recordResults = try await privateDatabase.records(matching: recordQuery)
        
        var remoteRecords: [TravelRecord] = []
        
        for (_, result) in recordResults.matchResults {
            guard let ckRecord = result else { continue }
            
            if let record = parseTravelRecord(from: ckRecord) {
                remoteRecords.append(record)
            }
        }
        
        // Merge remote records with local
        mergeRecords(local: travelData.travelRecords, remote: remoteRecords)
    }
    
    private func parseTravelRecord(from ckRecord: CKRecord) -> TravelRecord? {
        guard let placeTypeRaw = ckRecord["placeType"] as? String,
              let placeType = PlaceType(rawValue: placeTypeRaw),
              let name = ckRecord["name"] as? String,
              let country = ckRecord["country"] as? String,
              let continent = ckRecord["continent"] as? String,
              let latitude = ckRecord["latitude"] as? Double,
              let longitude = ckRecord["longitude"] as? Double,
              let visitDate = ckRecord["visitDate"] as? Date,
              let rating = ckRecord["rating"] as? Int,
              let tripTypeRaw = ckRecord["tripType"] as? String,
              let tripType = TripType(rawValue: tripTypeRaw) else {
            return nil
        }
        
        return TravelRecord(
            id: UUID(uuidString: ckRecord.recordID.recordName) ?? UUID(),
            placeType: placeType,
            name: name,
            country: country,
            continent: continent,
            coordinates: Coordinates(latitude: latitude, longitude: longitude),
            visitDate: visitDate,
            endDate: ckRecord["endDate"] as? Date,
            rating: rating,
            tripType: tripType,
            companions: ckRecord["companions"] as? [String] ?? [],
            budget: ckRecord["budget"] as? Double,
            notes: ckRecord["notes"] as? String ?? "",
            photos: ckRecord["photos"] as? [String] ?? [],
            weather: (ckRecord["weather"] as? String).flatMap { Weather(rawValue: $0) },
            activities: (ckRecord["activities"] as? [String] ?? []).compactMap { Activity(rawValue: $0) },
            accommodation: ckRecord["accommodation"] as? String,
            highlights: ckRecord["highlights"] as? [String] ?? [],
            wouldRevisit: ckRecord["wouldRevisit"] as? Bool ?? true,
            tags: ckRecord["tags"] as? [String] ?? []
        )
    }
    
    // MARK: - Merge & Conflict Resolution
    
    private func mergeRecords(local: [TravelRecord], remote: [TravelRecord]) {
        let travelData = TravelData()
        var mergedRecords = local
        
        for remoteRecord in remote {
            if let index = mergedRecords.firstIndex(where: { $0.id == remoteRecord.id }) {
                // Record exists locally - check which is newer
                // For simplicity, we'll use the remote version
                mergedRecords[index] = remoteRecord
            } else {
                // New record from remote
                mergedRecords.append(remoteRecord)
            }
        }
        
        // Update local data
        travelData.travelRecords = mergedRecords
        travelData.saveData()
    }
    
    private func mergeConflicts() async throws {
        // Simple last-write-wins strategy
        // In a production app, you'd want more sophisticated conflict resolution
    }
    
    // MARK: - Delete All Remote Data
    
    func deleteAllRemoteData() async throws {
        let userQuery = CKQuery(recordType: "User", predicate: NSPredicate(value: true))
        let userResults = try await privateDatabase.records(matching: userQuery)
        
        for (recordID, _) in userResults.matchResults {
            try await privateDatabase.deleteRecord(withID: recordID)
        }
        
        let recordQuery = CKQuery(recordType: "TravelRecord", predicate: NSPredicate(value: true))
        let recordResults = try await privateDatabase.records(matching: recordQuery)
        
        for (recordID, _) in recordResults.matchResults {
            try await privateDatabase.deleteRecord(withID: recordID)
        }
    }
}

// MARK: - SwiftUI Integration

struct CloudSyncStatusView: View {
    @ObservedObject var cloudManager = CloudKitManager.shared
    @State private var showingSettings = false
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: cloudManager.syncStatus.icon)
                .font(.system(size: 14))
                .foregroundColor(statusColor)
                .rotationEffect(.degrees(cloudManager.syncStatus == .syncing ? 360 : 0))
                .animation(cloudManager.syncStatus == .syncing ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: cloudManager.syncStatus.icon)
            
            Text(statusText)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            if cloudManager.iCloudSyncEnabled && cloudManager.iCloudAvailable {
                Button(action: {
                    Task {
                        await cloudManager.sync()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "FF0080"))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .onTapGesture {
            showingSettings = true
        }
        .sheet(isPresented: $showingSettings) {
            CloudSyncSettingsView()
        }
    }
    
    var statusColor: Color {
        switch cloudManager.syncStatus {
        case .idle: return .gray
        case .syncing: return Color(hex: "0080FF")
        case .success: return .green
        case .error: return .red
        }
    }
    
    var statusText: String {
        if !cloudManager.iCloudAvailable {
            return "iCloud not available"
        } else if !cloudManager.iCloudSyncEnabled {
            return "iCloud sync disabled"
        } else if let lastSync = cloudManager.lastSyncDate {
            return "Synced \(lastSync.formatted(.relative(presentation: .numeric)))"
        } else {
            return cloudManager.syncStatus.description
        }
    }
}

struct CloudSyncSettingsView: View {
    @ObservedObject var cloudManager = CloudKitManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Enable iCloud Sync", isOn: $cloudManager.iCloudSyncEnabled)
                    
                    if cloudManager.iCloudAvailable {
                        Label(cloudManager.syncStatus.description, systemImage: cloudManager.syncStatus.icon)
                            .foregroundColor(.secondary)
                    } else {
                        Label("iCloud not available", systemImage: "exclamationmark.icloud")
                            .foregroundColor(.red)
                    }
                } header: {
                    Text("iCloud Sync")
                } footer: {
                    Text("Keep your travel data synced across all your devices with iCloud.")
                }
                
                if cloudManager.iCloudAvailable && cloudManager.iCloudSyncEnabled {
                    Section("Actions") {
                        Button(action: {
                            Task {
                                await cloudManager.sync()
                            }
                        }) {
                            Label("Sync Now", systemImage: "arrow.clockwise")
                        }
                        
                        Button(role: .destructive, action: {
                            Task {
                                try await cloudManager.deleteAllRemoteData()
                            }
                        }) {
                            Label("Delete Remote Data", systemImage: "trash")
                        }
                    }
                }
                
                Section("Info") {
                    if let lastSync = cloudManager.lastSyncDate {
                        HStack {
                            Text("Last Sync")
                            Spacer()
                            Text(lastSync.formatted())
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Sync Status")
                        Spacer()
                        Text(cloudManager.syncStatus.description)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("iCloud Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}