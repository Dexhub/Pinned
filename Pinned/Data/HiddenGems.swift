import Foundation

struct HiddenGem {
    let name: String
    let alternativeTo: String
    let description: String
    let archetype: TravelArchetype
}

struct HiddenGems {
    static let gems = [
        // Basic Backpacker alternatives
        HiddenGem(
            name: "Shkoder, Albania",
            alternativeTo: "Dubrovnik, Croatia",
            description: "Same Balkan vibes, 90% fewer cruise ships",
            archetype: .basicBackpacker
        ),
        HiddenGem(
            name: "Vang Vieng, Laos",
            alternativeTo: "Pai, Thailand",
            description: "River tubing without the Instagram crowds",
            archetype: .basicBackpacker
        ),
        HiddenGem(
            name: "Salta, Argentina",
            alternativeTo: "Cusco, Peru",
            description: "Andean culture minus the Machu Picchu masses",
            archetype: .basicBackpacker
        ),
        
        // Comfort Crusader alternatives
        HiddenGem(
            name: "Comporta, Portugal",
            alternativeTo: "Mykonos, Greece",
            description: "Chic beach vibes, Portuguese prices",
            archetype: .comfortCrusader
        ),
        HiddenGem(
            name: "Gstaad, Switzerland",
            alternativeTo: "St. Moritz, Switzerland",
            description: "Same luxury, less Russian oligarchs",
            archetype: .comfortCrusader
        ),
        HiddenGem(
            name: "Aman Sveti Stefan, Montenegro",
            alternativeTo: "Santorini, Greece",
            description: "Island luxury without the crowds",
            archetype: .comfortCrusader
        ),
        
        // Culture Vulture alternatives
        HiddenGem(
            name: "Plovdiv, Bulgaria",
            alternativeTo: "Athens, Greece",
            description: "Roman ruins without the tourist hordes",
            archetype: .cultureVulture
        ),
        HiddenGem(
            name: "Luang Prabang, Laos",
            alternativeTo: "Angkor Wat, Cambodia",
            description: "Buddhist temples, French colonial charm",
            archetype: .cultureVulture
        ),
        HiddenGem(
            name: "Matera, Italy",
            alternativeTo: "Rome, Italy",
            description: "Cave dwellings older than the Colosseum",
            archetype: .cultureVulture
        ),
        
        // Digital Nomad alternatives
        HiddenGem(
            name: "Canggu, Indonesia",
            alternativeTo: "Ubud, Indonesia",
            description: "Surf, WiFi, and fewer yoga retreats",
            archetype: .digitalNomad
        ),
        HiddenGem(
            name: "Madeira, Portugal",
            alternativeTo: "Lisbon, Portugal",
            description: "Island life with fiber internet",
            archetype: .digitalNomad
        ),
        HiddenGem(
            name: "Medellin, Colombia",
            alternativeTo: "Mexico City, Mexico",
            description: "Perfect weather, growing tech scene",
            archetype: .digitalNomad
        ),
        
        // Adventure Junkie alternatives
        HiddenGem(
            name: "Faroe Islands",
            alternativeTo: "Iceland",
            description: "Same dramatic landscapes, no tour buses",
            archetype: .adventureJunkie
        ),
        HiddenGem(
            name: "Huacachina, Peru",
            alternativeTo: "Atacama, Chile",
            description: "Sandboarding in a desert oasis",
            archetype: .adventureJunkie
        ),
        HiddenGem(
            name: "Socotra Island, Yemen",
            alternativeTo: "Galapagos Islands",
            description: "Alien landscapes, dragon blood trees",
            archetype: .adventureJunkie
        ),
        
        // Foodie Wanderer alternatives
        HiddenGem(
            name: "Oaxaca, Mexico",
            alternativeTo: "Mexico City, Mexico",
            description: "Mezcal, mole, and less traffic",
            archetype: .foodieWanderer
        ),
        HiddenGem(
            name: "Penang, Malaysia",
            alternativeTo: "Bangkok, Thailand",
            description: "Street food capital without the chaos",
            archetype: .foodieWanderer
        ),
        HiddenGem(
            name: "San Sebastian, Spain",
            alternativeTo: "Barcelona, Spain",
            description: "More Michelin stars per capita",
            archetype: .foodieWanderer
        ),
        
        // Off-Grid Ghost alternatives
        HiddenGem(
            name: "Svalbard, Norway",
            alternativeTo: "Greenland",
            description: "More polar bears than people",
            archetype: .offGridGhost
        ),
        HiddenGem(
            name: "Easter Island, Chile",
            alternativeTo: "Machu Picchu, Peru",
            description: "Mysterious statues, middle of nowhere",
            archetype: .offGridGhost
        ),
        HiddenGem(
            name: "Salar de Uyuni, Bolivia",
            alternativeTo: "Patagonia",
            description: "Mars on Earth, no WiFi required",
            archetype: .offGridGhost
        ),
        
        // Weekend Warrior alternatives
        HiddenGem(
            name: "Ljubljana, Slovenia",
            alternativeTo: "Prague, Czech Republic",
            description: "Fairy tale city, half the tourists",
            archetype: .weekendWarrior
        ),
        HiddenGem(
            name: "Porto, Portugal",
            alternativeTo: "Barcelona, Spain",
            description: "Port wine > Sangria",
            archetype: .weekendWarrior
        ),
        HiddenGem(
            name: "Tallinn, Estonia",
            alternativeTo: "Copenhagen, Denmark",
            description: "Medieval meets digital nomad heaven",
            archetype: .weekendWarrior
        )
    ]
    
    static func getRecommendations(for archetype: TravelArchetype, visitedPlaces: Set<String>) -> [HiddenGem] {
        return gems
            .filter { $0.archetype == archetype }
            .filter { !visitedPlaces.contains($0.name) }
            .shuffled()
            .prefix(5)
            .map { $0 }
    }
    
    static let roastsByPattern: [(pattern: (Set<String>) -> Bool, roast: String)] = [
        (
            pattern: { places in
                places.contains("Paris") && places.contains("London") && places.contains("Rome")
            },
            roast: "The European starter pack. How brave of you."
        ),
        (
            pattern: { places in
                places.contains("Bali") && places.contains("Thailand") && places.count < 10
            },
            roast: "Gap year vibes strong with this one."
        ),
        (
            pattern: { places in
                places.isSuperset(of: ["Japan", "South Korea", "China"])
            },
            roast: "Asia tour complete. Did you try any food that wasn't in a mall?"
        ),
        (
            pattern: { places in
                places.count > 30 && !places.contains("Africa")
            },
            roast: "30+ countries but skipping an entire continent? Interesting choice."
        ),
        (
            pattern: { places in
                places.allSatisfy { CountryData.majorCities.contains($0) }
            },
            roast: "Only cities? Nature called, you sent it to voicemail."
        )
    ]
}