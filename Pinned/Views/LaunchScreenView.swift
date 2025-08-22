import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Premium Liquid Gradient Background
            LiquidGradient(colors: [
                Color(hex: "FF0080"),
                Color(hex: "FF8C00"),
                Color(hex: "0080FF")
            ])
            .ignoresSafeArea()
            
            // Particle Effect
            ParticleEffect(
                particleCount: 30,
                colors: [.white.opacity(0.3), Color(hex: "FF0080").opacity(0.2)]
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // App Icon with Neon Glow
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                        .neonGlow(color: Color(hex: "FF0080"), radius: 20)
                    
                    Image(systemName: "map.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: "FF0080"))
                        .rotationEffect(.degrees(isAnimating ? 10 : -10))
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                .threeDRotation(axis: (x: 0, y: 1, z: 0), perspective: 0.5)
                
                // App Name
                Text("Pinned")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(opacity)
                
                // Tagline
                Text("Track Your World")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
            
            isAnimating = true
            
            // Transition to main app after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                // Main app will handle the transition
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}