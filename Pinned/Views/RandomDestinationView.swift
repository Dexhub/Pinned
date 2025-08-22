import SwiftUI
import MapKit

struct RandomDestinationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var travelData: TravelData
    @State private var selectedDestination: CountryInfo?
    @State private var isSpinning = false
    @State private var showingDetails = false
    @State private var rotationAngle: Double = 0
    
    var unvisitedCountries: [CountryInfo] {
        WorldDatabase.countries.filter { country in
            !travelData.visitedCountries.contains(country.name)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(hex: "FF0080").opacity(0.1), Color(hex: "0080FF").opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "dice.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Color(hex: "FF0080"))
                            .rotationEffect(.degrees(rotationAngle))
                            .animation(isSpinning ? .linear(duration: 2).repeatForever(autoreverses: false) : .default, value: rotationAngle)
                        
                        Text("Random Destination")
                            .font(.system(size: 28, weight: .bold))
                        
                        Text("\(unvisitedCountries.count) countries you haven't visited yet")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Destination Card
                    if let destination = selectedDestination {
                        DestinationCard(country: destination, isShowing: showingDetails)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .scale.combined(with: .opacity)
                            ))
                            .onTapGesture {
                                HapticManager.shared.impact(.light)
                                withAnimation(.spring()) {
                                    showingDetails.toggle()
                                }
                            }
                    } else {
                        // Placeholder
                        VStack(spacing: 20) {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 80))
                                .foregroundColor(.gray.opacity(0.3))
                            
                            Text("Tap the button to discover\nyour next adventure!")
                                .font(.system(size: 18))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(height: 300)
                    }
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        Button(action: spinForDestination) {
                            HStack {
                                Image(systemName: isSpinning ? "stop.circle.fill" : "dice")
                                    .font(.system(size: 20))
                                
                                Text(isSpinning ? "Spinning..." : "Spin for Destination")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "FF0080"), Color(hex: "FF8C00")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                        }
                        .disabled(isSpinning || unvisitedCountries.isEmpty)
                        
                        if selectedDestination != nil {
                            HStack(spacing: 12) {
                                Button(action: addToVisited) {
                                    Label("Add to Map", systemImage: "plus.circle.fill")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(hex: "00C851"))
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color(hex: "00C851").opacity(0.1))
                                .cornerRadius(12)
                                
                                Button(action: shareDestination) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(hex: "0080FF"))
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color(hex: "0080FF").opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
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
    
    private func spinForDestination() {
        guard !unvisitedCountries.isEmpty else { return }
        
        HapticManager.shared.impact(.medium)
        SoundManager.shared.play(.quiz)
        
        withAnimation {
            isSpinning = true
            rotationAngle += 720 // Two full rotations
        }
        
        // Simulate spinning animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring()) {
                isSpinning = false
                selectedDestination = unvisitedCountries.randomElement()
                showingDetails = false
            }
            
            HapticManager.shared.playSuccess()
            SoundManager.shared.play(.success)
        }
    }
    
    private func addToVisited() {
        guard let destination = selectedDestination else { return }
        
        HapticManager.shared.playCountryAdded()
        SoundManager.shared.play(.countryAdded)
        
        travelData.addCountry(destination.name)
        
        // Show success feedback
        withAnimation {
            selectedDestination = nil
        }
        
        // Optionally dismiss after adding
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dismiss()
        }
    }
    
    private func shareDestination() {
        guard let destination = selectedDestination else { return }
        
        let message = "I just discovered \(destination.name) as my next travel destination using Pinned! 🌍✈️"
        
        let activityController = UIActivityViewController(
            activityItems: [message],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityController, animated: true)
        }
    }
}

// MARK: - Destination Card
struct DestinationCard: View {
    let country: CountryInfo
    let isShowing: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Map Preview
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: country.coordinates.latitude,
                    longitude: country.coordinates.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            )), annotationItems: [country]) { item in
                MapMarker(coordinate: CLLocationCoordinate2D(
                    latitude: item.coordinates.latitude,
                    longitude: item.coordinates.longitude
                ), tint: Color(hex: "FF0080"))
            }
            .frame(height: 200)
            .disabled(true)
            .overlay(
                LinearGradient(
                    colors: [Color.clear, Color.black.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Country Info
            VStack(spacing: 16) {
                // Country Name & Flag
                VStack(spacing: 8) {
                    Text(country.flag)
                        .font(.system(size: 60))
                    
                    Text(country.name)
                        .font(.system(size: 24, weight: .bold))
                    
                    HStack {
                        Text(country.continent.rawValue)
                        Text("•")
                        Text(country.capital)
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                }
                
                if isShowing {
                    // Additional Details
                    VStack(spacing: 12) {
                        Divider()
                        
                        // Quick Facts
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            FactPill(icon: "building.2", text: "\(country.majorCities.count) major cities")
                            FactPill(icon: "globe", text: country.region)
                            if let currency = country.currency {
                                FactPill(icon: "dollarsign.circle", text: currency)
                            }
                            if let language = country.languages.first {
                                FactPill(icon: "bubble.left", text: language)
                            }
                        }
                        
                        // Fun Fact
                        if let funFact = getRandomFunFact(for: country.name) {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Fun Fact", systemImage: "lightbulb.fill")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: "0080FF"))
                                
                                Text(funFact)
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(hex: "0080FF").opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .push(from: .bottom).combined(with: .opacity),
                        removal: .push(from: .top).combined(with: .opacity)
                    ))
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(hex: "FF0080").opacity(0.3), lineWidth: 1)
        )
    }
    
    func getRandomFunFact(for country: String) -> String? {
        let facts: [String: [String]] = [
            "Japan": [
                "Has over 6,800 islands",
                "Vending machines sell everything from hot coffee to umbrellas",
                "The world's oldest company was founded here in 578 AD"
            ],
            "Iceland": [
                "Has no mosquitoes",
                "Most of the country runs on renewable energy",
                "Has more books published per capita than any other country"
            ],
            "Brazil": [
                "Home to 60% of the Amazon rainforest",
                "Has won the World Cup 5 times",
                "The only Portuguese-speaking country in South America"
            ],
            "New Zealand": [
                "Has more sheep than people",
                "Was the last major landmass to be inhabited",
                "Home to the world's smallest dolphin"
            ]
        ]
        
        return facts[country]?.randomElement() ?? "An amazing destination waiting to be explored!"
    }
}

struct FactPill: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "FF0080"))
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

#Preview {
    RandomDestinationView()
        .environmentObject(TravelData())
}