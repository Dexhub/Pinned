import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var travelData: TravelData
    @State private var name = ""
    @State private var animateText = false
    @FocusState private var isNameFocused: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "FF0080"), Color(hex: "0080FF")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("So, you think you're")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("well-traveled?")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(animateText ? 1.0 : 0.9)
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: animateText)
                    
                    Text("🌍")
                        .font(.system(size: 80))
                        .rotationEffect(.degrees(animateText ? 10 : -10))
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateText)
                }
                
                Spacer()
                
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What's your name?")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        TextField("", text: $name, prompt: Text("Your passport name, not your DJ name")
                            .foregroundColor(.white.opacity(0.5)))
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            )
                            .focused($isNameFocused)
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: {
                        if !name.isEmpty {
                            withAnimation(.spring()) {
                                travelData.completeOnboarding(name: name)
                            }
                        }
                    }) {
                        Text("Let's Go!")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "FF0080"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(50)
                            .opacity(name.isEmpty ? 0.7 : 1.0)
                    }
                    .padding(.horizontal, 30)
                    .disabled(name.isEmpty)
                }
                
                Spacer()
                    .frame(height: 40)
            }
        }
        .onAppear {
            withAnimation {
                animateText = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isNameFocused = true
            }
        }
    }
}


#Preview {
    OnboardingView()
        .environmentObject(TravelData())
}