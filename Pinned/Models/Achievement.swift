import Foundation
import SwiftUI

enum AchievementCategory: String, CaseIterable {
    case explorer = "Explorer"
    case social = "Social"
    case adventure = "Adventure"
    case collector = "Collector"
    case special = "Special"
}

struct Achievement: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let icon: String
    let category: AchievementCategory
    let requirement: (TravelStats) -> Bool
    let points: Int
    let color: Color
    
    static let allAchievements: [Achievement] = [
        // Explorer Achievements
        Achievement(
            name: "First Steps",
            description: "Visit your first country",
            icon: "figure.walk",
            category: .explorer,
            requirement: { stats in stats.totalCountries >= 1 },
            points: 10,
            color: Color(hex: "FF0080")
        ),
        Achievement(
            name: "Continental Drift",
            description: "Visit all 7 continents",
            icon: "globe.americas.fill",
            category: .explorer,
            requirement: { stats in stats.continentCount >= 7 },
            points: 100,
            color: Color(hex: "0080FF")
        ),
        Achievement(
            name: "World Wanderer",
            description: "Visit 50 countries",
            icon: "airplane",
            category: .explorer,
            requirement: { stats in stats.totalCountries >= 50 },
            points: 50,
            color: Color(hex: "00FF80")
        ),
        Achievement(
            name: "Globe Trotter",
            description: "Visit 100 countries",
            icon: "globe",
            category: .explorer,
            requirement: { stats in stats.totalCountries >= 100 },
            points: 100,
            color: Color(hex: "FF8000")
        ),
        
        // Social Achievements
        Achievement(
            name: "Travel Buddy",
            description: "Travel with 5 different companions",
            icon: "person.2.fill",
            category: .social,
            requirement: { stats in
                let uniqueCompanions = Set(stats.favoriteCompanions.map { $0.companion })
                return uniqueCompanions.count >= 5
            },
            points: 20,
            color: Color(hex: "8000FF")
        ),
        Achievement(
            name: "Solo Explorer",
            description: "Take 10 solo trips",
            icon: "person.fill",
            category: .social,
            requirement: { stats in
                stats.records.filter { $0.tripType == .solo }.count >= 10
            },
            points: 30,
            color: Color(hex: "FF0080")
        ),
        
        // Adventure Achievements
        Achievement(
            name: "Island Hopper",
            description: "Visit 10 island nations",
            icon: "leaf.fill",
            category: .adventure,
            requirement: { stats in
                let islandCountries = stats.records
                    .map { $0.country }
                    .compactMap { WorldDatabase.getCountryByName($0) }
                    .filter { $0.hasIslands }
                return Set(islandCountries.map { $0.name }).count >= 10
            },
            points: 40,
            color: Color(hex: "00CCFF")
        ),
        Achievement(
            name: "City Slicker",
            description: "Visit 50 different cities",
            icon: "building.2.fill",
            category: .adventure,
            requirement: { stats in stats.totalCities >= 50 },
            points: 30,
            color: Color(hex: "FF00CC")
        ),
        Achievement(
            name: "Weekend Warrior",
            description: "Take 20 trips of 3 days or less",
            icon: "calendar",
            category: .adventure,
            requirement: { stats in
                stats.records.filter { $0.duration <= 3 }.count >= 20
            },
            points: 25,
            color: Color(hex: "FFCC00")
        ),
        
        // Collector Achievements
        Achievement(
            name: "Memory Keeper",
            description: "Add notes to 25 travel records",
            icon: "note.text",
            category: .collector,
            requirement: { stats in
                stats.records.filter { !$0.notes.isEmpty }.count >= 25
            },
            points: 20,
            color: Color(hex: "00FF00")
        ),
        Achievement(
            name: "Five Star Traveler",
            description: "Rate 10 places with 5 stars",
            icon: "star.fill",
            category: .collector,
            requirement: { stats in
                stats.topRatedPlaces.count >= 10
            },
            points: 25,
            color: Color(hex: "FFD700")
        ),
        
        // Special Achievements
        Achievement(
            name: "Around the World",
            description: "Travel more than 40,000 km total",
            icon: "dot.radiowaves.left.and.right",
            category: .special,
            requirement: { stats in stats.distanceTraveled >= 40000 },
            points: 50,
            color: Color(hex: "FF1493")
        ),
        Achievement(
            name: "Frequent Flyer",
            description: "Visit 20 countries in one year",
            icon: "airplane.departure",
            category: .special,
            requirement: { stats in
                stats.yearlyBreakdown.first?.countries.count ?? 0 >= 20
            },
            points: 60,
            color: Color(hex: "4169E1")
        ),
        Achievement(
            name: "All Seasons",
            description: "Travel in all four seasons",
            icon: "snowflake",
            category: .special,
            requirement: { stats in
                let seasons = Set(stats.records.map { $0.season })
                return seasons.count >= 4
            },
            points: 30,
            color: Color(hex: "20B2AA")
        )
    ]
    
    static func unlockedAchievements(for stats: TravelStats) -> [Achievement] {
        return allAchievements.filter { $0.requirement(stats) }
    }
    
    static func totalPoints(for stats: TravelStats) -> Int {
        return unlockedAchievements(for: stats).reduce(0) { $0 + $1.points }
    }
    
    static func nextAchievements(for stats: TravelStats, limit: Int = 3) -> [Achievement] {
        let unlocked = Set(unlockedAchievements(for: stats).map { $0.id })
        return allAchievements
            .filter { !unlocked.contains($0.id) }
            .sorted { a, b in
                // Sort by how close the user is to achieving it
                return progressTowards(achievement: a, stats: stats) > progressTowards(achievement: b, stats: stats)
            }
            .prefix(limit)
            .map { $0 }
    }
    
    private static func progressTowards(achievement: Achievement, stats: TravelStats) -> Double {
        // This is a simplified progress calculation
        // In a real app, you'd calculate actual progress for each achievement
        switch achievement.name {
        case "First Steps":
            return Double(stats.totalCountries) / 1.0
        case "World Wanderer":
            return Double(stats.totalCountries) / 50.0
        case "Globe Trotter":
            return Double(stats.totalCountries) / 100.0
        case "Continental Drift":
            return Double(stats.continentCount) / 7.0
        case "City Slicker":
            return Double(stats.totalCities) / 50.0
        default:
            return 0.0
        }
    }
}