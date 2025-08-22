import SwiftUI

// MARK: - Animated Globe
struct AnimatedGlobe: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "0080FF"), Color(hex: "00CCFF")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Continents overlay
            Circle()
                .fill(Color(hex: "00FF80").opacity(0.3))
                .frame(width: 60, height: 60)
                .offset(x: -20, y: -10)
            
            Circle()
                .fill(Color(hex: "FF0080").opacity(0.3))
                .frame(width: 40, height: 40)
                .offset(x: 15, y: 20)
            
            Circle()
                .fill(Color(hex: "FFD700").opacity(0.3))
                .frame(width: 30, height: 30)
                .offset(x: -10, y: 25)
        }
        .rotation3DEffect(
            .degrees(rotation),
            axis: (x: 0, y: 1, z: 0)
        )
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Pulse Animation
struct PulseAnimation: View {
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    let color: Color
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                    scale = 2.0
                    opacity = 0.0
                }
            }
    }
}

// MARK: - Confetti View
struct ConfettiView: View {
    @State private var isAnimating = false
    let colors: [Color] = [
        Color(hex: "FF0080"),
        Color(hex: "0080FF"),
        Color(hex: "00FF80"),
        Color(hex: "FFD700"),
        Color(hex: "FF00CC")
    ]
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece(
                    color: colors[index % colors.count],
                    size: CGFloat.random(in: 4...8),
                    delay: Double(index) * 0.02,
                    isAnimating: $isAnimating
                )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct ConfettiPiece: View {
    let color: Color
    let size: CGFloat
    let delay: Double
    @Binding var isAnimating: Bool
    
    @State private var position = CGPoint(x: 0, y: 0)
    @State private var opacity: Double = 1.0
    @State private var rotation: Double = 0
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .position(position)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                let randomX = CGFloat.random(in: -150...150)
                let randomEndX = randomX + CGFloat.random(in: -50...50)
                
                withAnimation(.easeOut(duration: 1.5).delay(delay)) {
                    position = CGPoint(x: randomEndX, y: -200)
                    opacity = 0
                    rotation = Double.random(in: 180...540)
                }
                
                withAnimation(.easeIn(duration: 0.5).delay(delay + 1.0)) {
                    position = CGPoint(x: randomEndX, y: 400)
                }
            }
    }
}

// MARK: - Shimmer Effect
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.3),
                        Color.white.opacity(0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 200)
                .offset(x: phase * 400 - 200)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

// MARK: - Bounce Animation
struct BounceAnimation: ViewModifier {
    @State private var bounce = false
    let delay: Double
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(bounce ? 1.2 : 1.0)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5).delay(delay)) {
                    bounce = true
                }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5).delay(delay + 0.1)) {
                    bounce = false
                }
            }
    }
}

extension View {
    func bounceEffect(delay: Double = 0) -> some View {
        modifier(BounceAnimation(delay: delay))
    }
}

// MARK: - Floating Animation
struct FloatingAnimation: ViewModifier {
    @State private var offset: CGFloat = 0
    let amplitude: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    offset = amplitude
                }
            }
    }
}

extension View {
    func floating(amplitude: CGFloat = 10) -> some View {
        modifier(FloatingAnimation(amplitude: amplitude))
    }
}

// MARK: - Success Checkmark
struct SuccessCheckmark: View {
    @State private var trim: CGFloat = 0
    @State private var scale: CGFloat = 0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "00FF80").opacity(0.1))
                .scaleEffect(scale)
            
            Circle()
                .stroke(Color(hex: "00FF80"), lineWidth: 3)
                .scaleEffect(scale)
            
            Path { path in
                path.move(to: CGPoint(x: 20, y: 50))
                path.addLine(to: CGPoint(x: 40, y: 70))
                path.addLine(to: CGPoint(x: 80, y: 30))
            }
            .trim(from: 0, to: trim)
            .stroke(Color(hex: "00FF80"), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .scaleEffect(scale)
        }
        .frame(width: 100, height: 100)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                scale = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                trim = 1.0
            }
        }
    }
}

// MARK: - Loading Dots
struct LoadingDots: View {
    @State private var animating = [false, false, false]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color(hex: "FF0080"))
                    .frame(width: 12, height: 12)
                    .scaleEffect(animating[index] ? 1.5 : 1.0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.6).repeatForever().delay(Double(index) * 0.2)) {
                            animating[index] = true
                        }
                    }
            }
        }
    }
}

// MARK: - Animated Counter
struct AnimatedCounter: View {
    let value: Int
    @State private var displayValue: Int = 0
    
    var body: some View {
        Text("\(displayValue)")
            .onAppear {
                animateValue()
            }
            .onChange(of: value) { _ in
                animateValue()
            }
    }
    
    func animateValue() {
        let steps = 30
        let stepDuration = 1.0 / Double(steps)
        let increment = value / steps
        
        for step in 0..<steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step) * stepDuration) {
                displayValue = min(increment * (step + 1), value)
            }
        }
    }
}

// MARK: - Preview
struct AnimatedComponents_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            AnimatedGlobe()
                .frame(width: 100, height: 100)
            
            ZStack {
                PulseAnimation(color: Color(hex: "FF0080"), size: 50)
                Circle()
                    .fill(Color(hex: "FF0080"))
                    .frame(width: 50, height: 50)
            }
            
            Text("Shimmer Text")
                .font(.title)
                .fontWeight(.bold)
                .shimmer()
            
            Image(systemName: "airplane")
                .font(.system(size: 50))
                .floating()
            
            SuccessCheckmark()
            
            LoadingDots()
            
            AnimatedCounter(value: 42)
                .font(.system(size: 48, weight: .bold))
        }
        .padding()
    }
}