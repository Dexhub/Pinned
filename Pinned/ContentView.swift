//
//  ContentView.swift
//  Pinned
//
//  Created by Himanshu on 7/20/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var travelData: TravelData
    @Binding var deepLink: DeepLink?
    
    var body: some View {
        if !travelData.hasCompletedOnboarding {
            OnboardingView()
        } else if travelData.shouldShowQuiz() {
            TravelQuizView()
        } else {
            MainTabView(deepLink: $deepLink)
        }
    }
}

#Preview {
    ContentView(deepLink: .constant(nil))
        .environmentObject(TravelData())
}
