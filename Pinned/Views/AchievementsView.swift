import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var travelData: TravelData
    @State private var selectedCategory: AchievementCategory? = nil
    @State private var showingShareSheet = false
    
    var unlockedAchievements: [Achievement] {
        Achievement.unlockedAchievements(for: travelData.stats)
    }
    
    var totalPoints: Int {
        Achievement.totalPoints(for: travelData.stats)
    }
    
    var nextAchievements: [Achievement] {
        Achievement.nextAchievements(for: travelData.stats, limit: 3)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Stats
                    VStack(spacing: 12) {
                        Text("\(totalPoints)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Color(hex: "FF0080"))
                        
                        Text("Achievement Points")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 20) {
                            VStack(spacing: 4) {
                                Text("\(unlockedAchievements.count)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(hex: "0080FF"))
                                Text("Unlocked")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Divider()
                                .frame(height: 30)
                            
                            VStack(spacing: 4) {
                                Text("\(Achievement.allAchievements.count)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.gray)
                                Text("Total")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(16)
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryChip(
                                title: "All",
                                isSelected: selectedCategory == nil,
                                action: { selectedCategory = nil }
                            )
                            
                            ForEach(AchievementCategory.allCases, id: \.self) { category in
                                CategoryChip(
                                    title: category.rawValue,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Next to Unlock Section
                    if !nextAchievements.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Next to Unlock")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                ForEach(nextAchievements) { achievement in
                                    NextAchievementCard(
                                        achievement: achievement,
                                        progress: getProgress(for: achievement)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Unlocked Achievements
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Unlocked Achievements")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal)
                        
                        if unlockedAchievements.isEmpty {
                            EmptyAchievementsView()
                                .padding()
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(filteredAchievements) { achievement in
                                    AchievementCard(
                                        achievement: achievement,
                                        isUnlocked: true
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // All Achievements
                    VStack(alignment: .leading, spacing: 12) {
                        Text("All Achievements")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(filteredLockedAchievements) { achievement in
                                AchievementCard(
                                    achievement: achievement,
                                    isUnlocked: false
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareAchievementsView(
                userName: travelData.userName,
                totalPoints: totalPoints,
                unlockedCount: unlockedAchievements.count,
                topAchievements: Array(unlockedAchievements.prefix(3))
            )
        }
    }
    
    var filteredAchievements: [Achievement] {
        if let category = selectedCategory {
            return unlockedAchievements.filter { $0.category == category }
        }
        return unlockedAchievements
    }
    
    var filteredLockedAchievements: [Achievement] {
        let unlockedIds = Set(unlockedAchievements.map { $0.id })
        let locked = Achievement.allAchievements.filter { !unlockedIds.contains($0.id) }
        
        if let category = selectedCategory {
            return locked.filter { $0.category == category }
        }
        return locked
    }
    
    func getProgress(for achievement: Achievement) -> Double {
        // Calculate progress based on achievement requirements
        switch achievement.name {
        case "First Steps":
            return min(Double(travelData.stats.totalCountries) / 1.0, 1.0)
        case "World Wanderer":
            return min(Double(travelData.stats.totalCountries) / 50.0, 1.0)
        case "Globe Trotter":
            return min(Double(travelData.stats.totalCountries) / 100.0, 1.0)
        case "Continental Drift":
            return min(Double(travelData.stats.continentCount) / 7.0, 1.0)
        case "City Slicker":
            return min(Double(travelData.stats.totalCities) / 50.0, 1.0)
        default:
            return 0.0
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ? Color(hex: "FF0080") : Color.gray.opacity(0.1)
                )
                .cornerRadius(20)
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? achievement.color : Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isUnlocked ? .white : .gray)
            }
            
            Text(achievement.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isUnlocked ? .primary : .gray)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text("\(achievement.points) pts")
                .font(.caption)
                .foregroundColor(isUnlocked ? achievement.color : .gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isUnlocked ? achievement.color.opacity(0.3) : Color.clear, lineWidth: 2)
                )
        )
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
}

struct NextAchievementCard: View {
    let achievement: Achievement
    let progress: Double
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.name)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(achievement.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(achievement.color)
                            .frame(width: geometry.size.width * progress, height: 4)
                    }
                }
                .frame(height: 4)
            }
            
            Spacer()
            
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct EmptyAchievementsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "trophy")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Start Your Journey!")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.gray)
            
            Text("Add your first country to begin unlocking achievements")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
    }
}

struct ShareAchievementsView: View {
    let userName: String
    let totalPoints: Int
    let unlockedCount: Int
    let topAchievements: [Achievement]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                ShareableAchievementCard(
                    userName: userName,
                    totalPoints: totalPoints,
                    unlockedCount: unlockedCount,
                    topAchievements: topAchievements
                )
                
                Spacer()
            }
            .navigationTitle("Share Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ShareableAchievementCard: View {
    let userName: String
    let totalPoints: Int
    let unlockedCount: Int
    let topAchievements: [Achievement]
    
    @State private var showingShareSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Card content (similar to ShareableCardView but for achievements)
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "FF0080"), Color(hex: "8000FF")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(spacing: 30) {
                    Text("\(userName)'s Achievements")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 20) {
                        Text("\(totalPoints)")
                            .font(.system(size: 64, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Achievement Points")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    if !topAchievements.isEmpty {
                        VStack(spacing: 16) {
                            Text("Latest Unlocks")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                            
                            VStack(spacing: 12) {
                                ForEach(topAchievements) { achievement in
                                    HStack {
                                        Image(systemName: achievement.icon)
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                        
                                        Text(achievement.name)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Text("+\(achievement.points)")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 5) {
                        Text("Level up with")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        Text("Pinned")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                }
                .padding(30)
            }
            .frame(width: 350, height: 500)
            .cornerRadius(20)
            .shadow(radius: 20)
            
            Button(action: { showingShareSheet = true }) {
                Label("Share Achievements", systemImage: "square.and.arrow.up")
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
            ShareSheet(items: [
                "I've earned \(totalPoints) achievement points in Pinned! 🏆\n\nUnlocked \(unlockedCount) travel achievements so far.\n\nTrack your own travels with Pinned 📍"
            ])
        }
    }
}

#Preview {
    AchievementsView()
        .environmentObject(TravelData())
}