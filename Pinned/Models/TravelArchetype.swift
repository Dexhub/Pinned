import SwiftUI

enum TravelArchetype: String, CaseIterable {
    case basicBackpacker = "The Basic Backpacker"
    case comfortCrusader = "The Comfort Crusader"
    case cultureVulture = "The Culture Vulture"
    case digitalNomad = "The Digital Nomad"
    case adventureJunkie = "The Adventure Junkie"
    case foodieWanderer = "The Foodie Wanderer"
    case offGridGhost = "The Off-Grid Ghost"
    case weekendWarrior = "The Weekend Warrior"
    
    var emoji: String {
        switch self {
        case .basicBackpacker: return "🎒"
        case .comfortCrusader: return "🏨"
        case .cultureVulture: return "🎭"
        case .digitalNomad: return "💻"
        case .adventureJunkie: return "🧗"
        case .foodieWanderer: return "🍜"
        case .offGridGhost: return "👻"
        case .weekendWarrior: return "⚡"
        }
    }
    
    var description: String {
        switch self {
        case .basicBackpacker:
            return "Hits every spot in Lonely Planet. Thinks hostels are a personality trait."
        case .comfortCrusader:
            return "5-star or bust. Your idea of roughing it is a 4-star hotel."
        case .cultureVulture:
            return "Actually learns the language. Makes locals uncomfortable with enthusiasm."
        case .digitalNomad:
            return "Works from 'paradise'. WiFi speed > Beach views."
        case .adventureJunkie:
            return "If it's not dangerous, why go? Insurance companies hate you."
        case .foodieWanderer:
            return "Travels for the stomach. Plans trips around restaurant reservations."
        case .offGridGhost:
            return "Allergic to tourist spots. If it's on Instagram, you're not going."
        case .weekendWarrior:
            return "48-hour city breaks only. Mastered the art of the carry-on."
        }
    }
    
    var traits: [String] {
        switch self {
        case .basicBackpacker:
            return ["Follows the crowd", "Budget obsessed", "Hostel enthusiast"]
        case .comfortCrusader:
            return ["Luxury lover", "Comfort first", "Pool required"]
        case .cultureVulture:
            return ["History buff", "Museum regular", "Language learner"]
        case .digitalNomad:
            return ["Remote worker", "Coffee shop hunter", "Visa runner"]
        case .adventureJunkie:
            return ["Thrill seeker", "Risk taker", "Story collector"]
        case .foodieWanderer:
            return ["Restaurant researcher", "Market explorer", "Snack hoarder"]
        case .offGridGhost:
            return ["Crowd avoider", "Path maker", "Secret keeper"]
        case .weekendWarrior:
            return ["Time optimizer", "City sprinter", "Red-eye expert"]
        }
    }
    
    var color: Color {
        switch self {
        case .basicBackpacker: return Color(red: 0.2, green: 0.6, blue: 0.9)
        case .comfortCrusader: return Color(red: 0.8, green: 0.7, blue: 0.3)
        case .cultureVulture: return Color(red: 0.6, green: 0.3, blue: 0.7)
        case .digitalNomad: return Color(red: 0.3, green: 0.8, blue: 0.6)
        case .adventureJunkie: return Color(red: 0.9, green: 0.3, blue: 0.3)
        case .foodieWanderer: return Color(red: 0.9, green: 0.5, blue: 0.3)
        case .offGridGhost: return Color(red: 0.4, green: 0.4, blue: 0.6)
        case .weekendWarrior: return Color(red: 0.7, green: 0.3, blue: 0.9)
        }
    }
}