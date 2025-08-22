import SwiftUI

struct TravelQuizView: View {
    @EnvironmentObject var travelData: TravelData
    @State private var currentQuestion = 0
    @State private var answers: [String] = []
    @State private var showResult = false
    
    let questions = [
        QuizQuestion(
            question: "Your ideal accommodation?",
            options: [
                "Hostel bunk bed (more money for activities!)",
                "Boutique hotel (comfort matters)",
                "Local Airbnb (live like a local)",
                "Tent under stars (nature is my hotel)"
            ]
        ),
        QuizQuestion(
            question: "You see a street food vendor. You:",
            options: [
                "Already eating before thinking",
                "Google reviews first",
                "Ask a local for recommendations",
                "Find the nearest McDonald's"
            ]
        ),
        QuizQuestion(
            question: "Your Instagram feed is mostly:",
            options: [
                "Sunset pics with deep captions",
                "Food. So much food.",
                "Selfies at famous landmarks",
                "I deleted Instagram to 'live in the moment'"
            ]
        ),
        QuizQuestion(
            question: "Perfect travel day includes:",
            options: [
                "Museum hopping and historical sites",
                "Beach/pool and cocktails",
                "Getting lost in random neighborhoods",
                "Extreme sports and adrenaline"
            ]
        ),
        QuizQuestion(
            question: "You pack:",
            options: [
                "One backpack, that's it",
                "Checked bag with outfit options",
                "Just my laptop and chargers",
                "Whatever fits after my camping gear"
            ]
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "FF0080"), Color(hex: "0080FF")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if showResult {
                QuizResultView(answers: answers)
            } else {
                VStack(spacing: 30) {
                    // Progress
                    HStack {
                        ForEach(0..<questions.count, id: \.self) { index in
                            Circle()
                                .fill(index <= currentQuestion ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                    
                    VStack(spacing: 40) {
                        Text("Time to find out what kind of traveler you really are")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        Text(questions[currentQuestion].question)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ForEach(Array(questions[currentQuestion].options.enumerated()), id: \.offset) { index, option in
                                Button(action: {
                                    selectAnswer(option)
                                }) {
                                    Text(option)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(hex: "FF0080"))
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                    
                    Spacer()
                    Spacer()
                }
            }
        }
    }
    
    func selectAnswer(_ answer: String) {
        answers.append(answer)
        
        if currentQuestion < questions.count - 1 {
            withAnimation(.spring()) {
                currentQuestion += 1
            }
        } else {
            withAnimation(.spring()) {
                showResult = true
            }
        }
    }
}

struct QuizQuestion {
    let question: String
    let options: [String]
}

struct QuizResultView: View {
    @EnvironmentObject var travelData: TravelData
    let answers: [String]
    @State private var showingArchetype = false
    @State private var determinedArchetype: TravelArchetype?
    
    var body: some View {
        VStack(spacing: 40) {
            if let archetype = determinedArchetype {
                VStack(spacing: 20) {
                    Text(archetype.emoji)
                        .font(.system(size: 100))
                        .scaleEffect(showingArchetype ? 1.0 : 0.5)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showingArchetype)
                    
                    Text(archetype.rawValue)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(archetype.description)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    HStack(spacing: 20) {
                        ForEach(archetype.traits, id: \.self) { trait in
                            Text(trait)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(archetype.color)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(20)
                        }
                    }
                    
                    Button(action: {
                        travelData.setArchetype(archetype)
                    }) {
                        Text("Yep, that's me!")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "FF0080"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(50)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            determinedArchetype = calculateArchetype()
            withAnimation {
                showingArchetype = true
            }
        }
    }
    
    func calculateArchetype() -> TravelArchetype {
        // Simple logic based on answers
        let firstAnswer = answers[0]
        let secondAnswer = answers[1]
        let thirdAnswer = answers[2]
        let fourthAnswer = answers[3]
        let fifthAnswer = answers[4]
        
        // Hostel + Already eating + deleted Instagram + getting lost + one backpack = Off Grid Ghost
        if firstAnswer.contains("Hostel") && secondAnswer.contains("Already") && thirdAnswer.contains("deleted") {
            return .offGridGhost
        }
        
        // Boutique + Google reviews + selfies + beach = Comfort Crusader
        if firstAnswer.contains("Boutique") && secondAnswer.contains("Google") && fourthAnswer.contains("Beach") {
            return .comfortCrusader
        }
        
        // Airbnb + ask local + food pics + museums = Culture Vulture
        if firstAnswer.contains("Airbnb") && secondAnswer.contains("local") && fourthAnswer.contains("Museum") {
            return .cultureVulture
        }
        
        // Tent + already eating + deleted instagram + extreme = Adventure Junkie
        if firstAnswer.contains("Tent") && fourthAnswer.contains("Extreme") {
            return .adventureJunkie
        }
        
        // Any + any + food + any + laptop = Digital Nomad
        if fifthAnswer.contains("laptop") {
            return .digitalNomad
        }
        
        // Any + any + food pics + any = Foodie Wanderer
        if thirdAnswer.contains("Food") {
            return .foodieWanderer
        }
        
        // Hostel + any + sunset + getting lost + backpack = Basic Backpacker
        if firstAnswer.contains("Hostel") && fifthAnswer.contains("backpack") {
            return .basicBackpacker
        }
        
        // Default to Weekend Warrior
        return .weekendWarrior
    }
}

#Preview {
    TravelQuizView()
        .environmentObject(TravelData())
}