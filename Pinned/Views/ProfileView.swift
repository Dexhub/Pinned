import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var travelData: TravelData
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Profile Header
                        VStack(spacing: 16) {
                            if let archetype = travelData.travelArchetype {
                                Text(archetype.emoji)
                                    .font(.system(size: 80))
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(Color(hex: "FF0080"))
                            }
                            
                            Text("Hey \(travelData.userName)!")
                                .font(.system(size: 28, weight: .bold))
                            
                            if let archetype = travelData.travelArchetype {
                                Text(archetype.rawValue)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(archetype.color)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Share Card Preview
                        ShareableCard()
                            .environmentObject(travelData)
                            .frame(height: 400)
                            .padding(.horizontal)
                            .onTapGesture {
                                generateShareImage()
                            }
                        
                        // Action Buttons
                        VStack(spacing: 12) {
                            Button(action: generateShareImage) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Share Your Travel DNA")
                                }
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [Color(hex: "FF0080"), Color(hex: "0080FF")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                            
                            Button(action: retakeQuiz) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Retake Personality Quiz")
                                }
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(hex: "FF0080"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(hex: "FF0080").opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Settings Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Settings")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "person.fill",
                                    title: "Change Name",
                                    value: travelData.userName
                                ) {
                                    // Would show name change sheet
                                }
                                
                                Divider()
                                
                                SettingsRow(
                                    icon: "trash.fill",
                                    title: "Reset All Data",
                                    value: nil,
                                    isDestructive: true
                                ) {
                                    showingResetAlert = true
                                }
                            }
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        // Footer
                        VStack(spacing: 8) {
                            Text("Made with 🌍 for wanderers")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Text("Keep exploring, keep roasting")
                                .font(.system(size: 12))
                                .foregroundColor(.gray.opacity(0.7))
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingShareSheet) {
            if let image = shareImage {
                ShareSheet(items: [image])
            }
        }
        .alert("Reset Everything?", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                travelData.reset()
            }
        } message: {
            Text("This will delete all your places and start fresh. Sure about this?")
        }
    }
    
    func generateShareImage() {
        let card = ShareableCard()
            .environmentObject(travelData)
            .frame(width: 400, height: 500)
            .background(Color.white)
        
        let controller = UIHostingController(rootView: card)
        
        guard let view = controller.view else {
            print("Failed to create share image: view is nil")
            return
        }
        
        let targetSize = CGSize(width: 400, height: 500)
        view.bounds = CGRect(origin: .zero, size: targetSize)
        view.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        shareImage = image
        showingShareSheet = true
    }
    
    func retakeQuiz() {
        travelData.hasCompletedQuiz = false
        travelData.travelArchetype = nil
        travelData.saveData()
    }
}

struct ShareableCard: View {
    @EnvironmentObject var travelData: TravelData
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "FF0080"), Color(hex: "0080FF")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 20) {
                // Header
                Text("MY TRAVEL DNA")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
                    .tracking(2)
                
                // Archetype
                if let archetype = travelData.travelArchetype {
                    VStack(spacing: 12) {
                        Text(archetype.emoji)
                            .font(.system(size: 60))
                        
                        Text(archetype.rawValue)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 8) {
                            ForEach(archetype.traits, id: \.self) { trait in
                                Text(trait)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Color(hex: "FF0080"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white)
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
                
                // Stats
                HStack(spacing: 30) {
                    VStack(spacing: 4) {
                        Text("\(travelData.visitedCountries.count)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Text("Countries")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    VStack(spacing: 4) {
                        Text("\(Int(travelData.worldPercentage()))%")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Text("World")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    VStack(spacing: 4) {
                        Text("\(travelData.visitedCities.count)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Text("Cities")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                // Map visual (simplified)
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 100)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<20, id: \.self) { _ in
                            Circle()
                                .fill(Color.white.opacity(Double.random(in: 0.3...1.0)))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Footer
                VStack(spacing: 4) {
                    Text("PINNED")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(3)
                    
                    Text("Find out your travel personality")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(30)
        }
        .cornerRadius(20)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let value: String?
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(isDestructive ? .red : Color(hex: "FF0080"))
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isDestructive ? .red : .primary)
                
                Spacer()
                
                if let value = value {
                    Text(value)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding()
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ProfileView()
        .environmentObject(TravelData())
}