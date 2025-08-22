import SwiftUI

struct ScratchMapView: View {
    @EnvironmentObject var travelData: TravelData
    @State private var showingSearch = false
    @State private var searchText = ""
    @State private var selectedPlace: String?
    @State private var showingRoast = false
    @State private var currentRoast = ""
    @State private var recentlyAddedPlace: String?
    @State private var showingConfetti = false
    
    var filteredPlaces: [String] {
        if searchText.isEmpty {
            return []
        }
        
        let allCountries = WorldDatabase.countries.map { $0.name }
        let allCities = WorldDatabase.countries.flatMap { $0.majorCities }
        let allPlaces = allCountries + allCities
        return allPlaces
            .filter { !travelData.visitedCountries.contains($0) && !travelData.visitedCities.contains($0) }
            .filter { $0.localizedCaseInsensitiveContains(searchText) }
            .sorted()
            .prefix(10)
            .map { $0 }
    }
    
    var worldPercentage: Int {
        Int(travelData.worldPercentage())
    }
    
    var motivationalText: String {
        let count = travelData.visitedCountries.count
        switch count {
        case 0:
            return "0 countries? Even your couch has seen more action."
        case 1:
            return "One down, 194 to go. You got this!"
        case 2...5:
            return "Getting started! Still \(195 - count) countries to explore though..."
        case 6...10:
            return "Double digits! Still 95% of Earth to explore though..."
        case 11...25:
            return "Not bad! But have you been anywhere GOOD?"
        case 26...50:
            return "Okay show-off, but have you been anywhere cool?"
        case 51...100:
            return "Impressive! Starting to run out of easy countries?"
        default:
            return "World domination mode activated! 🌍"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search Bar
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Where have you actually been?", text: $searchText)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                        if !searchText.isEmpty {
                            Button("Cancel") {
                                searchText = ""
                            }
                            .foregroundColor(Color(hex: "FF0080"))
                            .font(.system(size: 16, weight: .medium))
                        }
                    }
                    .padding()
                    
                    // Stats Bar
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(travelData.visitedCountries.count)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color(hex: "FF0080"))
                            Text("Countries")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("\(worldPercentage)%")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color(hex: "0080FF"))
                            Text("World Explored")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(travelData.visitedCities.count)")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color(hex: "FF0080"))
                            Text("Cities")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    
                    // Motivational Text
                    Text(motivationalText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Search Results or Map
                    if !filteredPlaces.isEmpty {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(filteredPlaces, id: \.self) { place in
                                    Button(action: {
                                        addPlace(place)
                                    }) {
                                        HStack {
                                            Text(place)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(Color(hex: "FF0080"))
                                                .font(.system(size: 20))
                                        }
                                        .padding()
                                        .background(Color.white)
                                    }
                                    
                                    Divider()
                                }
                            }
                        }
                    } else {
                        // Interactive World Map
                        WorldMapView()
                            .environmentObject(travelData)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        .overlay(
            showingConfetti ? ConfettiView() : nil
        )
        .alert("Added!", isPresented: $showingRoast) {
            Button("Thanks, I guess") {
                showingRoast = false
                if travelData.shouldShowQuiz() {
                    // This will trigger the quiz through ContentView
                }
            }
        } message: {
            Text(currentRoast)
        }
    }
    
    func addPlace(_ place: String) {
        withAnimation(.spring()) {
            let allCountries = WorldDatabase.countries.map { $0.name }
            if allCountries.contains(place) {
                travelData.addCountry(place)
            } else {
                // For cities, create a travel record
                if let country = WorldDatabase.countries.first(where: { $0.majorCities.contains(place) }) {
                    let record = TravelRecord(
                        placeType: .city,
                        name: place,
                        country: country.name,
                        continent: country.continent.rawValue,
                        coordinates: Coordinates(
                            latitude: country.coordinates.latitude,
                            longitude: country.coordinates.longitude
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
                    travelData.addTravelRecord(record)
                }
            }
            
            currentRoast = getRoastForPlace(place)
            recentlyAddedPlace = place
            searchText = ""
            showingRoast = true
            
            // Show confetti for new countries
            showingConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showingConfetti = false
            }
        }
    }
    
    func getRoastForPlace(_ place: String) -> String {
        let roastLines: [String: String] = [
            "Paris": "Paris? How original. Let me guess, you 'found yourself' at the Eiffel Tower?",
            "Bali": "Bali? Did you go for the culture or just the Instagram likes?",
            "Iceland": "Iceland? Blue Lagoon selfie incoming in 3... 2... 1...",
            "Dubai": "Dubai? Because nothing says authentic travel like a city built yesterday.",
            "London": "London? Revolutionary. Next you'll tell me you rode the London Eye.",
            "New York": "New York? Groundbreaking. Did you also discover pizza exists?",
            "Tokyo": "Tokyo? Let me guess, you ate sushi and felt cultured?",
            "Bangkok": "Bangkok? Pad Thai on Khao San Road doesn't count as authentic.",
            "Barcelona": "Barcelona? Sagrada Familia and sangria. How unexpected.",
            "Amsterdam": "Amsterdam? I'm sure you went for the 'museums'.",
            "Rome": "Rome? Threw a coin in the Trevi? How unique of you.",
            "Sydney": "Sydney? Opera House photo from the exact same angle as everyone else?",
            "Los Angeles": "LA? Traffic and overpriced smoothies. Living the dream.",
            "Miami": "Miami? Spring break never ended for you, huh?",
            "Las Vegas": "Vegas? What happens there apparently goes on Instagram.",
            "default": "Oh wow, so adventurous. I bet no one's ever been there before."
        ]
        
        return roastLines[place] ?? roastLines["default"]!
    }
}

struct ScratchMapGrid: View {
    @EnvironmentObject var travelData: TravelData
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 10)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(0..<195, id: \.self) { index in
                    Rectangle()
                        .fill(randomGradient(for: index))
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(4)
                        .opacity(index < travelData.visitedCountries.count ? 1.0 : 0.2)
                }
            }
        }
    }
    
    func randomGradient(for index: Int) -> LinearGradient {
        if index < travelData.visitedCountries.count {
            let colors = [
                Color(hex: "FF0080"),
                Color(hex: "0080FF"),
                Color(hex: "00FF80"),
                Color(hex: "FF8000"),
                Color(hex: "8000FF")
            ]
            
            let color1 = colors[index % colors.count]
            let color2 = colors[(index + 1) % colors.count]
            
            return LinearGradient(
                colors: [color1, color2],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

#Preview {
    ScratchMapView()
        .environmentObject(TravelData())
}