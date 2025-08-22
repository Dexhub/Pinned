import SwiftUI

struct ShareableCardView: View {
    let userName: String
    let visitedCountries: Int
    let worldPercentage: Int
    let topCountries: [String]
    let travelArchetype: TravelArchetype?
    
    @State private var cardImage: UIImage?
    @State private var showingShareSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Card Content
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [Color(hex: "FF0080"), Color(hex: "0080FF")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Text("\(userName)'s Travel Stats")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        if let archetype = travelArchetype {
                            Text("The \(archetype.title)")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    
                    // Main Stats
                    HStack(spacing: 40) {
                        VStack(spacing: 8) {
                            Text("\(visitedCountries)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                            Text("Countries")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        VStack(spacing: 8) {
                            Text("\(worldPercentage)%")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                            Text("World Explored")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    // World Map Visual
                    WorldMapMiniView(visitedCountries: visitedCountries)
                        .frame(height: 120)
                        .padding(.horizontal, 20)
                    
                    // Top Countries
                    if !topCountries.isEmpty {
                        VStack(spacing: 10) {
                            Text("Recent Adventures")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                            
                            HStack {
                                ForEach(topCountries.prefix(3), id: \.self) { country in
                                    Text(country)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }
                    
                    // Call to Action
                    HStack(spacing: 5) {
                        Text("Track your travels with")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        Text("Pinned")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: "map.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                }
                .padding(30)
            }
            .frame(width: 350, height: 600)
            .cornerRadius(20)
            .shadow(radius: 20)
            
            // Share Button
            Button(action: shareCard) {
                Label("Share Your Travel Stats", systemImage: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "FF0080"))
                    .cornerRadius(12)
            }
            .padding()
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = cardImage {
                ShareSheet(items: [image, createShareText()])
            }
        }
    }
    
    func shareCard() {
        // Capture card as image
        let renderer = ImageRenderer(content: 
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "FF0080"), Color(hex: "0080FF")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Text("\(userName)'s Travel Stats")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        if let archetype = travelArchetype {
                            Text("The \(archetype.title)")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    
                    HStack(spacing: 40) {
                        VStack(spacing: 8) {
                            Text("\(visitedCountries)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                            Text("Countries")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        VStack(spacing: 8) {
                            Text("\(worldPercentage)%")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                            Text("World Explored")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    WorldMapMiniView(visitedCountries: visitedCountries)
                        .frame(height: 120)
                        .padding(.horizontal, 20)
                    
                    if !topCountries.isEmpty {
                        VStack(spacing: 10) {
                            Text("Recent Adventures")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                            
                            HStack {
                                ForEach(topCountries.prefix(3), id: \.self) { country in
                                    Text(country)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 5) {
                        Text("Track your travels with")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        Text("Pinned")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: "map.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                }
                .padding(30)
            }
            .frame(width: 350, height: 600)
        )
        
        renderer.scale = 3.0 // High quality
        
        if let uiImage = renderer.uiImage {
            cardImage = uiImage
            showingShareSheet = true
        }
    }
    
    func createShareText() -> String {
        var text = "I've visited \(visitedCountries) countries and explored \(worldPercentage)% of the world! 🌍"
        
        if let archetype = travelArchetype {
            text += "\n\nMy travel style: The \(archetype.title)"
        }
        
        text += "\n\nTrack your own travels with Pinned 📍"
        
        return text
    }
}

struct WorldMapMiniView: View {
    let visitedCountries: Int
    
    var body: some View {
        ZStack {
            // Simple world map representation
            GeometryReader { geometry in
                Path { path in
                    // Draw simplified continents
                    // North America
                    path.move(to: CGPoint(x: geometry.size.width * 0.2, y: geometry.size.height * 0.3))
                    path.addQuadCurve(
                        to: CGPoint(x: geometry.size.width * 0.35, y: geometry.size.height * 0.4),
                        control: CGPoint(x: geometry.size.width * 0.25, y: geometry.size.height * 0.25)
                    )
                    
                    // Europe
                    path.move(to: CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.25))
                    path.addQuadCurve(
                        to: CGPoint(x: geometry.size.width * 0.6, y: geometry.size.height * 0.35),
                        control: CGPoint(x: geometry.size.width * 0.55, y: geometry.size.height * 0.3)
                    )
                    
                    // Africa
                    path.move(to: CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.5))
                    path.addQuadCurve(
                        to: CGPoint(x: geometry.size.width * 0.55, y: geometry.size.height * 0.8),
                        control: CGPoint(x: geometry.size.width * 0.52, y: geometry.size.height * 0.65)
                    )
                    
                    // Asia
                    path.move(to: CGPoint(x: geometry.size.width * 0.65, y: geometry.size.height * 0.3))
                    path.addQuadCurve(
                        to: CGPoint(x: geometry.size.width * 0.85, y: geometry.size.height * 0.5),
                        control: CGPoint(x: geometry.size.width * 0.75, y: geometry.size.height * 0.35)
                    )
                    
                    // Australia
                    path.move(to: CGPoint(x: geometry.size.width * 0.75, y: geometry.size.height * 0.75))
                    path.addQuadCurve(
                        to: CGPoint(x: geometry.size.width * 0.85, y: geometry.size.height * 0.8),
                        control: CGPoint(x: geometry.size.width * 0.8, y: geometry.size.height * 0.78)
                    )
                }
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                
                // Visited dots
                ForEach(0..<min(visitedCountries, 20), id: \.self) { index in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ShareableCardView(
        userName: "John",
        visitedCountries: 42,
        worldPercentage: 22,
        topCountries: ["Japan", "Iceland", "New Zealand"],
        travelArchetype: .culturalExplorer
    )
}