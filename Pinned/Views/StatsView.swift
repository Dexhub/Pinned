import SwiftUI

struct StatsView: View {
    @EnvironmentObject var travelData: TravelData
    @State private var selectedSegment = 0
    
    var continentsVisited: Int {
        // Simple logic - would need proper mapping in real app
        let countries = travelData.visitedCountries
        var continents = Set<String>()
        
        if countries.contains(where: { ["United States", "Canada", "Mexico", "Brazil", "Argentina", "Chile", "Peru"].contains($0) }) {
            continents.insert("Americas")
        }
        if countries.contains(where: { ["France", "Germany", "Italy", "Spain", "United Kingdom", "Netherlands", "Greece"].contains($0) }) {
            continents.insert("Europe")
        }
        if countries.contains(where: { ["China", "Japan", "India", "Thailand", "Vietnam", "Indonesia", "Singapore"].contains($0) }) {
            continents.insert("Asia")
        }
        if countries.contains(where: { ["Egypt", "Morocco", "South Africa", "Kenya", "Tanzania", "Ethiopia"].contains($0) }) {
            continents.insert("Africa")
        }
        if countries.contains(where: { ["Australia", "New Zealand", "Fiji"].contains($0) }) {
            continents.insert("Oceania")
        }
        
        return continents.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header with archetype
                        if let archetype = travelData.travelArchetype {
                            VStack(spacing: 12) {
                                Text(archetype.emoji)
                                    .font(.system(size: 60))
                                
                                Text(archetype.rawValue)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(archetype.color)
                                
                                Text(archetype.description)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .padding(.top, 20)
                        }
                        
                        // Main Stats
                        HStack(spacing: 20) {
                            StatCard(
                                number: "\(travelData.visitedCountries.count)",
                                label: "Countries",
                                color: Color(hex: "FF0080")
                            )
                            
                            StatCard(
                                number: "\(continentsVisited)/7",
                                label: "Continents",
                                color: Color(hex: "0080FF")
                            )
                            
                            StatCard(
                                number: "\(travelData.visitedCities.count)",
                                label: "Cities",
                                color: Color(hex: "00FF80")
                            )
                        }
                        .padding(.horizontal)
                        
                        // World Percentage
                        VStack(spacing: 12) {
                            Text("\(Int(travelData.worldPercentage()))%")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(Color(hex: "FF0080"))
                            
                            Text("of the world explored")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 20)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "FF0080"), Color(hex: "0080FF")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: CGFloat(travelData.worldPercentage()) * 3, height: 20)
                            }
                            .frame(width: 300)
                        }
                        
                        // Recommendations based on archetype
                        if travelData.travelArchetype != nil {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Places you'd actually enjoy:")
                                    .font(.system(size: 20, weight: .bold))
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(getRecommendations(), id: \.self) { place in
                                            RecommendationCard(place: place)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        // Roasts section
                        VStack(spacing: 16) {
                            Text("Reality Check")
                                .font(.system(size: 20, weight: .bold))
                            
                            RoastCard(roast: getRoastForStats())
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Your Travel DNA")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func getRecommendations() -> [String] {
        guard let archetype = travelData.travelArchetype else { return [] }
        
        switch archetype {
        case .basicBackpacker:
            return ["Faroe Islands", "Albania", "Georgia", "Uzbekistan", "Bolivia"]
        case .comfortCrusader:
            return ["Maldives", "Dubai", "Singapore", "Monaco", "Seychelles"]
        case .cultureVulture:
            return ["Iran", "Ethiopia", "Myanmar", "Bhutan", "Madagascar"]
        case .digitalNomad:
            return ["Mexico City", "Lisbon", "Bali", "Bangkok", "Buenos Aires"]
        case .adventureJunkie:
            return ["Patagonia", "Nepal", "Iceland", "New Zealand", "Alaska"]
        case .foodieWanderer:
            return ["Peru", "Vietnam", "Morocco", "Georgia", "South Korea"]
        case .offGridGhost:
            return ["Socotra Island", "Svalbard", "Easter Island", "Faroe Islands", "Greenland"]
        case .weekendWarrior:
            return ["Prague", "Budapest", "Krakow", "Porto", "Valencia"]
        }
    }
    
    func getRoastForStats() -> String {
        let countries = travelData.visitedCountries
        
        if countries.count == 0 {
            return "You haven't been anywhere. Your passport is just an expensive ID card."
        }
        
        if countries.count < 5 {
            return "Less than 5 countries? Your goldfish has seen more of the world."
        }
        
        if countries.allSatisfy({ ["France", "Italy", "Spain", "Germany", "United Kingdom"].contains($0) }) {
            return "Only Europe? That's like saying you love food but only eat bread."
        }
        
        if countries.contains("Bali") && countries.contains("Thailand") && countries.count < 10 {
            return "Southeast Asia backpacker starter pack. How original."
        }
        
        if countries.count > 50 {
            return "Over 50 countries? Touch grass... wait, you probably have in every timezone."
        }
        
        return "Not bad, but are you traveling or just collecting passport stamps?"
    }
}

struct StatCard: View {
    let number: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(number)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct RecommendationCard: View {
    let place: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(place)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Text("You'd actually like this")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(width: 150)
        .background(
            LinearGradient(
                colors: [Color(hex: "FF0080"), Color(hex: "0080FF")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }
}

struct RoastCard: View {
    let roast: String
    
    var body: some View {
        HStack {
            Text("🔥")
                .font(.system(size: 30))
            
            Text(roast)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding()
        .background(Color(hex: "FF0080").opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    StatsView()
        .environmentObject(TravelData())
}