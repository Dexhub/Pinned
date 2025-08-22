import SwiftUI
import WidgetKit

enum DataError: LocalizedError {
    case encodingFailed(description: String)
    case decodingFailed(description: String)
    case corruptedData(description: String)
    
    var errorDescription: String? {
        switch self {
        case .encodingFailed(let description):
            return "Encoding failed: \(description)"
        case .decodingFailed(let description):
            return "Decoding failed: \(description)"
        case .corruptedData(let description):
            return "Corrupted data: \(description)"
        }
    }
}

class TravelData: ObservableObject {
    @Published var userName: String = ""
    @Published var travelRecords: [TravelRecord] = []
    @Published var livedPlaces: [LivedPlace] = []
    @Published var travelArchetype: TravelArchetype?
    @Published var hasCompletedOnboarding: Bool = false
    @Published var hasCompletedQuiz: Bool = false
    @Published var quizAnswers: [String] = []
    
    private let userNameKey = "pinned_userName"
    private let recordsKey = "pinned_travelRecords"
    private let livedPlacesKey = "pinned_livedPlaces"
    private let archetypeKey = "pinned_archetype"
    private let onboardingKey = "pinned_onboarding"
    private let quizKey = "pinned_quiz"
    
    // Computed properties for backward compatibility
    var visitedCountries: Set<String> {
        Set(travelRecords.map { $0.country })
    }
    
    var visitedCities: Set<String> {
        Set(travelRecords.filter { $0.placeType == .city }.map { $0.name })
    }
    
    var stats: TravelStats {
        TravelStats(records: travelRecords, livedPlaces: livedPlaces)
    }
    
    init() {
        loadData()
    }
    
    func loadData() {
        do {
            userName = UserDefaults.standard.string(forKey: userNameKey) ?? ""
            hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
            hasCompletedQuiz = UserDefaults.standard.bool(forKey: quizKey)
            
            // Load travel records with error handling
            if let recordsData = UserDefaults.standard.data(forKey: recordsKey) {
                do {
                    let decodedRecords = try JSONDecoder().decode([TravelRecord].self, from: recordsData)
                    travelRecords = decodedRecords
                } catch {
                    print("Error loading travel records: \(error)")
                    // Create backup and reset records
                    backupCorruptedData(data: recordsData, key: recordsKey)
                    travelRecords = []
                }
            }
            
            // Load lived places with error handling
            if let livedData = UserDefaults.standard.data(forKey: livedPlacesKey) {
                do {
                    let decodedLived = try JSONDecoder().decode([LivedPlace].self, from: livedData)
                    livedPlaces = decodedLived
                } catch {
                    print("Error loading lived places: \(error)")
                    backupCorruptedData(data: livedData, key: livedPlacesKey)
                    livedPlaces = []
                }
            }
            
            // Load archetype safely
            if let archetypeRaw = UserDefaults.standard.string(forKey: archetypeKey),
               let archetype = TravelArchetype(rawValue: archetypeRaw) {
                travelArchetype = archetype
            }
            
        } catch {
            print("Critical error loading data: \(error)")
            // Show error to user via notification
            NotificationCenter.default.post(name: .init("DataLoadError"), object: error)
        }
    }
    
    private func backupCorruptedData(data: Data, key: String) {
        let backupKey = "\(key)_backup_\(Date().timeIntervalSince1970)"
        UserDefaults.standard.set(data, forKey: backupKey)
        print("Corrupted data backed up to key: \(backupKey)")
    }
    
    func saveData() {
        do {
            UserDefaults.standard.set(userName, forKey: userNameKey)
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: onboardingKey)
            UserDefaults.standard.set(hasCompletedQuiz, forKey: quizKey)
            
            // Save travel records with error handling
            do {
                let encodedRecords = try JSONEncoder().encode(travelRecords)
                UserDefaults.standard.set(encodedRecords, forKey: recordsKey)
            } catch {
                print("Error saving travel records: \(error)")
                throw DataError.encodingFailed(description: "Failed to save travel records")
            }
            
            // Save lived places with error handling
            do {
                let encodedLived = try JSONEncoder().encode(livedPlaces)
                UserDefaults.standard.set(encodedLived, forKey: livedPlacesKey)
            } catch {
                print("Error saving lived places: \(error)")
                throw DataError.encodingFailed(description: "Failed to save lived places")
            }
            
            // Save archetype
            if let archetype = travelArchetype {
                UserDefaults.standard.set(archetype.rawValue, forKey: archetypeKey)
            }
            
            // Sync widget data
            syncWidgetData()
            
        } catch {
            print("Critical error saving data: \(error)")
            NotificationCenter.default.post(name: .init("DataSaveError"), object: error)
        }
    }
    
    private func syncWidgetData() {
        // Calculate stats for widget
        let countriesVisited = visitedCountries.count
        let continentsVisited = Set(travelRecords.map { $0.continent }).count
        let worldPercentage = worldPercentage()
        let totalTrips = travelRecords.count
        
        // Find favorite country (most visited)
        let countryVisits = Dictionary(grouping: travelRecords, by: { $0.country })
        let favoriteCountry = countryVisits.max { $0.value.count < $1.value.count }?.key ?? "None"
        
        // Determine next milestone
        let nextMilestone: String
        if countriesVisited < 10 {
            nextMilestone = "Visit 10 countries"
        } else if countriesVisited < 25 {
            nextMilestone = "Visit 25 countries"
        } else if countriesVisited < 50 {
            nextMilestone = "Visit 50 countries"
        } else if continentsVisited < 7 {
            nextMilestone = "Visit all 7 continents"
        } else {
            nextMilestone = "Visit 100 countries"
        }
        
        // Create widget data
        let widgetData: [String: Any] = [
            "countriesVisited": countriesVisited,
            "continentsVisited": continentsVisited,
            "worldPercentage": worldPercentage,
            "totalTrips": totalTrips,
            "favoritCountry": favoriteCountry,
            "nextMilestone": nextMilestone
        ]
        
        // Save to shared UserDefaults
        if let sharedDefaults = UserDefaults(suiteName: "group.com.aethon.pinned") {
            do {
                let data = try JSONSerialization.data(withJSONObject: widgetData)
                sharedDefaults.set(data, forKey: "widgetStats")
                
                // Reload widgets
                WidgetCenter.shared.reloadAllTimelines()
            } catch {
                print("Error saving widget data: \(error)")
            }
        }
    }
    
    func addCountry(_ country: String) {
        // Create a basic record for backward compatibility
        if let countryInfo = WorldDatabase.getCountryByName(country) {
            let record = TravelRecord(
                placeType: .country,
                name: country,
                country: country,
                continent: countryInfo.continent.rawValue,
                coordinates: Coordinates(
                    latitude: countryInfo.coordinates.latitude,
                    longitude: countryInfo.coordinates.longitude
                ),
                visitDate: Date(),
                endDate: nil,
                rating: 3,
                tripType: .leisure,
                companions: [],
                budget: nil,
                notes: "",
                photos: [],
                weather: nil,
                activities: [],
                accommodation: nil,
                highlights: [],
                wouldRevisit: true,
                tags: []
            )
            travelRecords.append(record)
            saveData()
        }
    }
    
    func addTravelRecord(_ record: TravelRecord) {
        travelRecords.append(record)
        saveData()
    }
    
    func updateTravelRecord(_ record: TravelRecord) {
        if let index = travelRecords.firstIndex(where: { $0.id == record.id }) {
            travelRecords[index] = record
            saveData()
        }
    }
    
    func deleteTravelRecord(_ record: TravelRecord) {
        travelRecords.removeAll { $0.id == record.id }
        saveData()
    }
    
    func addLivedPlace(_ place: LivedPlace) {
        livedPlaces.append(place)
        saveData()
    }
    
    func updateLivedPlace(_ place: LivedPlace) {
        if let index = livedPlaces.firstIndex(where: { $0.id == place.id }) {
            livedPlaces[index] = place
            saveData()
        }
    }
    
    func deleteLivedPlace(_ place: LivedPlace) {
        livedPlaces.removeAll { $0.id == place.id }
        saveData()
    }
    
    func completeOnboarding(name: String) {
        userName = name
        hasCompletedOnboarding = true
        saveData()
    }
    
    func worldPercentage() -> Double {
        let totalCountries = 195.0
        return (Double(visitedCountries.count) / totalCountries) * 100
    }
    
    func shouldShowQuiz() -> Bool {
        return !hasCompletedQuiz && visitedCountries.count >= 5
    }
    
    func setArchetype(_ archetype: TravelArchetype) {
        travelArchetype = archetype
        hasCompletedQuiz = true
        saveData()
    }
    
    func reset() {
        userName = ""
        travelRecords.removeAll()
        livedPlaces.removeAll()
        travelArchetype = nil
        hasCompletedOnboarding = false
        hasCompletedQuiz = false
        quizAnswers.removeAll()
        saveData()
    }
}