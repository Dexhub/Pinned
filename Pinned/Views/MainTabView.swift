import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showingAddRecord = false
    @State private var showingShareSheet = false
    @State private var showingRandomDestination = false
    @Binding var deepLink: DeepLink?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ScratchMapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(0)
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(1)
            
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(2)
            
            AchievementsView()
                .tabItem {
                    Label("Awards", systemImage: "trophy.fill")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(Color(hex: "FF0080"))
        .overlay(
            // Floating Add Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showingAddRecord = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "FF0080"), Color(hex: "FF4080")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 90)
                }
            }
        )
        .sheet(isPresented: $showingAddRecord) {
            AddTravelRecordView()
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareableCardView()
        }
        .sheet(isPresented: $showingRandomDestination) {
            RandomDestinationView()
        }
        .onChange(of: deepLink) { newValue in
            handleDeepLink(newValue)
        }
        .onAppear {
            if let link = deepLink {
                handleDeepLink(link)
            }
        }
    }
    
    private func handleDeepLink(_ link: DeepLink?) {
        guard let link = link else { return }
        
        switch link {
        case .stats:
            selectedTab = 2
        case .addCountry:
            showingAddRecord = true
        case .share:
            showingShareSheet = true
        case .achievements:
            selectedTab = 3
        case .randomDestination:
            showingRandomDestination = true
        case .country(let countryName):
            // Handle country-specific deep link
            selectedTab = 0
        }
        
        // Clear the deep link after handling
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            deepLink = nil
        }
    }
}

#Preview {
    MainTabView(deepLink: .constant(nil))
        .environmentObject(TravelData())
}