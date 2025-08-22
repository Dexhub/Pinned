import SwiftUI

struct InteractiveMapView: View {
    @EnvironmentObject var travelData: TravelData
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var dragOffset: CGSize = .zero
    @State private var hoveredCountry: Country?
    @State private var selectedCountry: Country?
    @State private var showingCountryPopup = false
    @State private var scratchAnimations: [String: Bool] = [:]
    @State private var showingRoast = false
    @State private var currentRoast = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Map Container
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    ZStack {
                        // Water/Ocean background
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "E6F3FF"), Color(hex: "B8E0FF")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: WorldMapData.mapSize.width * scale,
                                   height: WorldMapData.mapSize.height * scale)
                        
                        // Countries
                        ForEach(WorldMapData.detailedCountries, id: \.code) { country in
                            CountryShape(
                                country: country,
                                isVisited: travelData.visitedCountries.contains(country.name),
                                isHovered: hoveredCountry?.code == country.code,
                                isScratchAnimating: scratchAnimations[country.code] ?? false
                            )
                            .scaleEffect(scale)
                            .onTapGesture {
                                handleCountryTap(country)
                            }
                            .onHover { isHovered in
                                if isHovered {
                                    hoveredCountry = country
                                } else if hoveredCountry?.code == country.code {
                                    hoveredCountry = nil
                                }
                            }
                        }
                        
                        // Country labels for visited countries
                        ForEach(WorldMapData.detailedCountries.filter { travelData.visitedCountries.contains($0.name) }, id: \.code) { country in
                            Text(country.code)
                                .font(.system(size: 12 * scale, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                                .position(
                                    x: country.center.x * scale,
                                    y: country.center.y * scale
                                )
                                .allowsHitTesting(false)
                        }
                    }
                    .frame(width: WorldMapData.mapSize.width * scale,
                           height: WorldMapData.mapSize.height * scale)
                }
                .offset(x: offset.width + dragOffset.width,
                        y: offset.height + dragOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            offset.width += value.translation.width
                            offset.height += value.translation.height
                            dragOffset = .zero
                        }
                )
                
                // Zoom controls
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            Button(action: zoomIn) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(hex: "FF0080"))
                                    .background(Circle().fill(Color.white))
                            }
                            
                            Button(action: zoomOut) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(hex: "FF0080"))
                                    .background(Circle().fill(Color.white))
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .background(Color(hex: "F0F8FF"))
        .alert("Scratched off!", isPresented: $showingRoast) {
            Button("Nice") {
                showingRoast = false
                if travelData.shouldShowQuiz() {
                    // This will trigger the quiz through ContentView
                }
            }
        } message: {
            Text(currentRoast)
        }
        .overlay(
            // Country info popup
            Group {
                if let country = selectedCountry, showingCountryPopup {
                    CountryPopup(
                        country: country,
                        isVisited: travelData.visitedCountries.contains(country.name),
                        onAdd: {
                            addCountry(country)
                        },
                        onClose: {
                            selectedCountry = nil
                            showingCountryPopup = false
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        )
    }
    
    func handleCountryTap(_ country: Country) {
        if travelData.visitedCountries.contains(country.name) {
            // Already visited - maybe show stats or remove option
            return
        }
        
        selectedCountry = country
        withAnimation(.spring()) {
            showingCountryPopup = true
        }
    }
    
    func addCountry(_ country: Country) {
        // Trigger scratch animation
        withAnimation(.easeInOut(duration: 0.6)) {
            scratchAnimations[country.code] = true
        }
        
        // Add country after animation starts
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            travelData.addCountry(country.name)
            showingCountryPopup = false
            
            // Show roast
            currentRoast = getRoastForCountry(country.name)
            showingRoast = true
        }
        
        // Reset animation state
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            scratchAnimations[country.code] = false
        }
    }
    
    func zoomIn() {
        withAnimation(.spring()) {
            scale = min(scale * 1.5, 3.0)
        }
    }
    
    func zoomOut() {
        withAnimation(.spring()) {
            scale = max(scale / 1.5, 0.5)
        }
    }
    
    func getRoastForCountry(_ country: String) -> String {
        let roastLines: [String: String] = [
            "United States": "USA? How original. Let me guess, New York or LA?",
            "France": "Paris? Found yourself at the Eiffel Tower?",
            "Italy": "Italy? Threw a coin in the Trevi? Revolutionary.",
            "United Kingdom": "UK? Revolutionary. Next you'll tell me you rode the London Eye.",
            "Japan": "Japan? Let me guess, you ate sushi and felt cultured?",
            "Spain": "Spain? Sagrada Familia and sangria. How unexpected.",
            "Thailand": "Thailand? Pad Thai on Khao San Road doesn't count as authentic.",
            "Australia": "Australia? Opera House photo from the exact same angle as everyone else?",
            "Germany": "Germany? Oktoberfest doesn't count as cultural immersion.",
            "Mexico": "Mexico? All-inclusive resort or actual Mexico?",
            "Canada": "Canada? It's just America with healthcare.",
            "Brazil": "Brazil? Copacabana beach and caipirinhas, groundbreaking.",
            "India": "India? Found yourself at an ashram?",
            "China": "China? Great Wall selfie incoming.",
            "Greece": "Greece? Santorini sunset like every influencer ever?",
            "Netherlands": "Amsterdam? I'm sure you went for the 'museums'.",
            "Indonesia": "Bali? Did you go for the culture or just the Instagram likes?",
            "Turkey": "Turkey? Hot air balloon in Cappadocia, how unique.",
            "Iceland": "Iceland? Blue Lagoon selfie incoming in 3... 2... 1...",
            "Morocco": "Morocco? Lost in the medina like every travel blogger?",
            "Egypt": "Egypt? Pyramid scheme tourist trap.",
            "South Africa": "South Africa? Safari selfies don't make you Nat Geo.",
            "Argentina": "Argentina? Tango lesson and steak dinner, riveting.",
            "Peru": "Peru? Machu Picchu at sunrise, never seen that before.",
            "New Zealand": "New Zealand? Lord of the Rings tour, how original.",
            "Portugal": "Portugal? Pastel de nata and port wine, groundbreaking.",
            "Vietnam": "Vietnam? Pho and motorbike tours, how authentic.",
            "United Arab Emirates": "Dubai? Because nothing says authentic travel like a city built yesterday.",
            "default": "Oh wow, so adventurous. I bet no one's ever been there before."
        ]
        
        return roastLines[country] ?? roastLines["default"]!
    }
}

struct CountryShape: View {
    let country: Country
    let isVisited: Bool
    let isHovered: Bool
    let isScratchAnimating: Bool
    
    @State private var scratchProgress: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Base country shape
            country.path
                .fill(isVisited ? countryGradient : unvisitedColor)
                .overlay(
                    country.path
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                .scaleEffect(isHovered ? 1.05 : 1.0)
                .animation(.spring(response: 0.3), value: isHovered)
            
            // Scratch-off animation overlay
            if isScratchAnimating {
                country.path
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.8), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .mask(
                        Rectangle()
                            .fill(Color.black)
                            .offset(x: -1000 + (1000 * scratchProgress))
                    )
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            scratchProgress = 2.0
                        }
                    }
            }
        }
    }
    
    var countryGradient: LinearGradient {
        let colors = [
            Color(hex: "FF0080"),
            Color(hex: "FF4080"),
            Color(hex: "FF0080").opacity(0.8)
        ]
        
        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var unvisitedColor: LinearGradient {
        LinearGradient(
            colors: [
                Color.gray.opacity(0.2),
                Color.gray.opacity(0.3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct CountryPopup: View {
    let country: Country
    let isVisited: Bool
    let onAdd: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(country.name)
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
            }
            
            if !isVisited {
                Text("Ready to scratch this one off?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                
                Button(action: onAdd) {
                    Text("Yes, I've been here!")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "FF0080"), Color(hex: "0080FF")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(30)
                }
            }
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
        .frame(width: 300)
        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    }
}

#Preview {
    InteractiveMapView()
        .environmentObject(TravelData())
}