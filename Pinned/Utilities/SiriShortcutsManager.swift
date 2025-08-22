import Foundation
import Intents
import IntentsUI
import SwiftUI

// MARK: - Siri Shortcuts Manager
class SiriShortcutsManager: NSObject, ObservableObject {
    static let shared = SiriShortcutsManager()
    
    @Published var donations: [INInteraction] = []
    
    override init() {
        super.init()
        setupShortcuts()
    }
    
    // MARK: - Shortcut Types
    enum ShortcutType: String, CaseIterable {
        case viewStats = "com.aethon.pinned.viewStats"
        case addCountry = "com.aethon.pinned.addCountry"
        case shareProgress = "com.aethon.pinned.shareProgress"
        case viewAchievements = "com.aethon.pinned.viewAchievements"
        case randomDestination = "com.aethon.pinned.randomDestination"
        
        var title: String {
            switch self {
            case .viewStats: return "View Travel Stats"
            case .addCountry: return "Add New Country"
            case .shareProgress: return "Share Travel Progress"
            case .viewAchievements: return "View Achievements"
            case .randomDestination: return "Suggest Random Destination"
            }
        }
        
        var suggestedPhrase: String {
            switch self {
            case .viewStats: return "Show my travel stats"
            case .addCountry: return "Add a country to Pinned"
            case .shareProgress: return "Share my travel map"
            case .viewAchievements: return "Show my travel achievements"
            case .randomDestination: return "Suggest a travel destination"
            }
        }
        
        var systemImageName: String {
            switch self {
            case .viewStats: return "chart.bar.fill"
            case .addCountry: return "plus.circle.fill"
            case .shareProgress: return "square.and.arrow.up"
            case .viewAchievements: return "trophy.fill"
            case .randomDestination: return "dice.fill"
            }
        }
    }
    
    // MARK: - Setup
    private func setupShortcuts() {
        // Donate default shortcuts
        for shortcutType in ShortcutType.allCases {
            donateShortcut(type: shortcutType)
        }
    }
    
    // MARK: - Donate Shortcuts
    func donateShortcut(type: ShortcutType, userInfo: [String: Any]? = nil) {
        let activity = NSUserActivity(activityType: type.rawValue)
        activity.title = type.title
        activity.userInfo = userInfo
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.persistentIdentifier = type.rawValue
        
        // Set suggested invocation phrase
        if #available(iOS 12.0, *) {
            activity.suggestedInvocationPhrase = type.suggestedPhrase
        }
        
        // Donate the activity
        activity.becomeCurrent()
        
        // Create an interaction for the activity
        let interaction = INInteraction(intent: createIntent(for: type), response: nil)
        interaction.donate { error in
            if let error = error {
                print("Error donating interaction: \(error)")
            }
        }
    }
    
    // MARK: - Create Intents
    private func createIntent(for type: ShortcutType) -> INIntent {
        switch type {
        case .viewStats:
            return createViewStatsIntent()
        case .addCountry:
            return createAddCountryIntent()
        case .shareProgress:
            return createShareProgressIntent()
        case .viewAchievements:
            return createViewAchievementsIntent()
        case .randomDestination:
            return createRandomDestinationIntent()
        }
    }
    
    private func createViewStatsIntent() -> INIntent {
        if #available(iOS 13.0, *) {
            let intent = INSearchForPhotosIntent()
            intent.searchTerms = ["travel", "stats"]
            return intent
        } else {
            return INIntent()
        }
    }
    
    private func createAddCountryIntent() -> INIntent {
        if #available(iOS 13.0, *) {
            let intent = INAddTasksIntent()
            intent.taskTitles = ["Add new country"]
            return intent
        } else {
            return INIntent()
        }
    }
    
    private func createShareProgressIntent() -> INIntent {
        let intent = INShareFocusStatusIntent()
        return intent
    }
    
    private func createViewAchievementsIntent() -> INIntent {
        if #available(iOS 13.0, *) {
            let intent = INSearchForPhotosIntent()
            intent.searchTerms = ["achievements", "travel"]
            return intent
        } else {
            return INIntent()
        }
    }
    
    private func createRandomDestinationIntent() -> INIntent {
        if #available(iOS 13.0, *) {
            let intent = INSearchForPhotosIntent()
            intent.searchTerms = ["random", "destination"]
            return intent
        } else {
            return INIntent()
        }
    }
    
    // MARK: - Handle Shortcuts
    func handleShortcut(userActivity: NSUserActivity) -> DeepLink? {
        guard let shortcutType = ShortcutType(rawValue: userActivity.activityType) else {
            return nil
        }
        
        switch shortcutType {
        case .viewStats:
            return .stats
        case .addCountry:
            return .addCountry
        case .shareProgress:
            return .share
        case .viewAchievements:
            return .achievements
        case .randomDestination:
            return .randomDestination
        }
    }
    
    // MARK: - Update Shortcuts
    func updateShortcutRelevance() {
        let travelData = TravelData()
        
        // Update relevance based on user behavior
        if travelData.visitedCountries.count > 0 {
            updateRelevance(for: .viewStats, score: 1.0)
            updateRelevance(for: .shareProgress, score: 0.8)
        }
        
        if travelData.visitedCountries.count > 5 {
            updateRelevance(for: .viewAchievements, score: 0.9)
        }
        
        // Suggest adding countries if user hasn't added any recently
        let recentRecords = travelData.travelRecords.filter {
            $0.visitDate > Date().addingTimeInterval(-7 * 24 * 60 * 60) // Last week
        }
        if recentRecords.isEmpty {
            updateRelevance(for: .addCountry, score: 1.0)
            updateRelevance(for: .randomDestination, score: 0.7)
        }
    }
    
    private func updateRelevance(for type: ShortcutType, score: Double) {
        let activity = NSUserActivity(activityType: type.rawValue)
        activity.title = type.title
        activity.isEligibleForPrediction = true
        
        if #available(iOS 12.0, *) {
            let attributes = CSSearchableItemAttributeSet(contentType: .content)
            attributes.contentDescription = type.title
            attributes.thumbnailData = UIImage(systemName: type.systemImageName)?.pngData()
            activity.contentAttributeSet = attributes
        }
        
        activity.becomeCurrent()
    }
}

// MARK: - Deep Link Support
enum DeepLink {
    case stats
    case addCountry
    case share
    case achievements
    case randomDestination
    case country(String)
}

// MARK: - Siri Shortcuts View
struct SiriShortcutsView: View {
    @ObservedObject var shortcutsManager = SiriShortcutsManager.shared
    @State private var selectedShortcut: SiriShortcutsManager.ShortcutType?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Add shortcuts to quickly access Pinned features with Siri")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                }
                
                Section("Available Shortcuts") {
                    ForEach(SiriShortcutsManager.ShortcutType.allCases, id: \.self) { shortcut in
                        ShortcutRow(shortcut: shortcut) {
                            selectedShortcut = shortcut
                            HapticManager.shared.selection()
                        }
                    }
                }
                
                Section("How to Use") {
                    VStack(alignment: .leading, spacing: 12) {
                        HowToStep(number: "1", text: "Tap any shortcut above")
                        HowToStep(number: "2", text: "Record your phrase or use the suggested one")
                        HowToStep(number: "3", text: "Say \"Hey Siri\" followed by your phrase")
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Siri Shortcuts")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $selectedShortcut) { shortcut in
            AddShortcutView(shortcut: shortcut)
        }
    }
}

struct ShortcutRow: View {
    let shortcut: SiriShortcutsManager.ShortcutType
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: shortcut.systemImageName)
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "FF0080"))
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(shortcut.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(""\(shortcut.suggestedPhrase)"")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "plus.circle")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "FF0080"))
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HowToStep: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color(hex: "FF0080"))
                .clipShape(Circle())
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct AddShortcutView: View {
    let shortcut: SiriShortcutsManager.ShortcutType
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            if #available(iOS 16.0, *) {
                VStack {
                    // Custom implementation for iOS 16+
                    Spacer()
                    
                    Image(systemName: shortcut.systemImageName)
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "FF0080"))
                        .padding()
                    
                    Text(shortcut.title)
                        .font(.system(size: 24, weight: .bold))
                        .padding(.bottom, 8)
                    
                    Text("Suggested phrase:")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    
                    Text(""\(shortcut.suggestedPhrase)"")
                        .font(.system(size: 18, weight: .medium))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .padding()
                    
                    Button(action: {
                        // Add shortcut
                        SiriShortcutsManager.shared.donateShortcut(type: shortcut)
                        HapticManager.shared.playSuccess()
                        dismiss()
                    }) {
                        Text("Add to Siri")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "FF0080"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .navigationTitle("Add Shortcut")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            } else {
                // Fallback for older iOS versions
                Text("Siri Shortcuts require iOS 16 or later")
                    .navigationTitle("Add Shortcut")
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
}

// MARK: - App Integration
extension View {
    func onContinueUserActivity(_ activityType: String, perform action: @escaping (NSUserActivity) -> ()) -> some View {
        self.onContinueUserActivity(activityType, perform: action)
    }
}

#Preview {
    SiriShortcutsView()
}