//
//  PinnedApp.swift
//  Pinned
//
//  Created by Himanshu on 7/20/25.
//

import SwiftUI

@main
struct PinnedApp: App {
    @StateObject private var travelData = TravelData()
    @State private var hasInitializationError = false
    @State private var showingLaunchScreen = true
    @State private var deepLink: DeepLink?
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showingLaunchScreen {
                    LaunchScreenView()
                        .transition(.opacity)
                } else if hasInitializationError {
                    ErrorView()
                } else {
                    ContentView(deepLink: $deepLink)
                        .environmentObject(travelData)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: showingLaunchScreen)
            .onAppear {
                // Validate initialization
                if !validateInitialization() {
                    hasInitializationError = true
                }
                
                // Hide launch screen after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    showingLaunchScreen = false
                }
                
                // Setup Siri shortcuts
                SiriShortcutsManager.shared.updateShortcutRelevance()
            }
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                handleUserActivity(userActivity)
            }
            .onContinueUserActivity("com.aethon.pinned.viewStats") { _ in
                deepLink = .stats
            }
            .onContinueUserActivity("com.aethon.pinned.addCountry") { _ in
                deepLink = .addCountry
            }
            .onContinueUserActivity("com.aethon.pinned.shareProgress") { _ in
                deepLink = .share
            }
            .onContinueUserActivity("com.aethon.pinned.viewAchievements") { _ in
                deepLink = .achievements
            }
            .onContinueUserActivity("com.aethon.pinned.randomDestination") { _ in
                deepLink = .randomDestination
            }
        }
    }
    
    private func validateInitialization() -> Bool {
        // Check if Color extension is loaded
        _ = Color(hex: "FF0080")
        
        // Check if world database is accessible
        return !WorldDatabase.countries.isEmpty
    }
    
    private func handleUserActivity(_ userActivity: NSUserActivity) {
        if let deepLink = SiriShortcutsManager.shared.handleShortcut(userActivity: userActivity) {
            self.deepLink = deepLink
        }
    }
}

struct ErrorView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Initialization Error")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Please restart the app to continue using Pinned")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                // Trigger app refresh by resetting state
                NotificationCenter.default.post(name: .init("RefreshApp"), object: nil)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
