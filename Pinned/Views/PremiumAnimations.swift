import SwiftUI

// MARK: - Particle Effect
struct ParticleEffect: View {
    let particleCount: Int
    let colors: [Color]
    @State private var particles: [Particle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                        .blur(radius: particle.blur)
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
                animateParticles()
            }
        }
    }
    
    private func createParticles(in size: CGSize) {
        particles = (0..<particleCount).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                color: colors.randomElement() ?? .white,
                size: CGFloat.random(in: 2...8),
                opacity: Double.random(in: 0.3...0.8),
                blur: CGFloat.random(in: 0...2)
            )
        }
    }
    
    private func animateParticles() {
        withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
            particles = particles.map { particle in
                var newParticle = particle
                newParticle.position.y -= 200
                return newParticle
            }
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let color: Color
    let size: CGFloat
    let opacity: Double
    let blur: CGFloat
}

// MARK: - Liquid Gradient Background
struct LiquidGradient: View {
    @State private var animate = false
    let colors: [Color]
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                BlobShape(animate: animate, index: index)
                    .fill(
                        LinearGradient(
                            colors: [colors[index % colors.count], colors[(index + 1) % colors.count]],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blur(radius: 30)
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: Double.random(in: 5...8))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.5),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct BlobShape: Shape {
    var animate: Bool
    let index: Int
    
    var animatableData: Double {
        get { animate ? 1 : 0 }
        set { }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        let points: [(x: CGFloat, y: CGFloat)] = [
            (0.2 + CGFloat(index) * 0.1, 0.3),
            (0.8 - CGFloat(index) * 0.1, 0.2),
            (0.9, 0.7 + CGFloat(index) * 0.1),
            (0.4, 0.9 - CGFloat(index) * 0.1),
            (0.1, 0.6)
        ]
        
        path.move(to: CGPoint(x: points[0].x * width, y: points[0].y * height))
        
        for i in 0..<points.count {
            let next = (i + 1) % points.count
            let control1 = CGPoint(
                x: (points[i].x + points[next].x) / 2 * width,
                y: points[i].y * height
            )
            let control2 = CGPoint(
                x: (points[i].x + points[next].x) / 2 * width,
                y: points[next].y * height
            )
            
            path.addCurve(
                to: CGPoint(x: points[next].x * width, y: points[next].y * height),
                control1: control1,
                control2: control2
            )
        }
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Morphing Shape Animation
struct MorphingShape: View {
    @State private var morph = false
    let fromShape: AnyShape
    let toShape: AnyShape
    let color: Color
    
    var body: some View {
        ZStack {
            if morph {
                toShape
                    .fill(color)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
            } else {
                fromShape
                    .fill(color)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever()) {
                morph.toggle()
            }
        }
    }
}

struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

// MARK: - Ripple Effect
struct RippleEffect: View {
    @State private var ripples: [Ripple] = []
    let color: Color
    
    var body: some View {
        ZStack {
            ForEach(ripples) { ripple in
                Circle()
                    .stroke(color, lineWidth: 2)
                    .frame(width: ripple.size, height: ripple.size)
                    .position(ripple.position)
                    .opacity(ripple.opacity)
            }
        }
        .onTapGesture { location in
            addRipple(at: location)
        }
    }
    
    private func addRipple(at location: CGPoint) {
        let ripple = Ripple(position: location)
        ripples.append(ripple)
        
        withAnimation(.easeOut(duration: 1)) {
            if let index = ripples.firstIndex(where: { $0.id == ripple.id }) {
                ripples[index].size = 200
                ripples[index].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ripples.removeAll { $0.id == ripple.id }
        }
    }
}

struct Ripple: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat = 0
    var opacity: Double = 1
}

// MARK: - Glitch Effect
struct GlitchEffect: ViewModifier {
    @State private var offset: CGSize = .zero
    @State private var color: Color = .clear
    let isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                content
                    .offset(offset)
                    .colorMultiply(color)
                    .opacity(isActive ? 0.8 : 0)
                    .blendMode(.screen)
            )
            .onChange(of: isActive) { active in
                if active {
                    animateGlitch()
                }
            }
    }
    
    private func animateGlitch() {
        withAnimation(.linear(duration: 0.1).repeatCount(5)) {
            offset = CGSize(
                width: CGFloat.random(in: -5...5),
                height: CGFloat.random(in: -5...5)
            )
            color = [Color.red, Color.green, Color.blue].randomElement() ?? .clear
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            offset = .zero
            color = .clear
        }
    }
}

// MARK: - 3D Rotation Effect
struct ThreeDRotation: ViewModifier {
    @State private var rotation: Double = 0
    let axis: (x: CGFloat, y: CGFloat, z: CGFloat)
    let perspective: CGFloat
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(rotation),
                axis: axis,
                perspective: perspective
            )
            .onAppear {
                withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

// MARK: - Neon Glow Effect
struct NeonGlow: ViewModifier {
    let color: Color
    let radius: CGFloat
    @State private var animating = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .shadow(color: color, radius: radius)
                .shadow(color: color, radius: radius)
                .shadow(color: color, radius: animating ? radius * 2 : radius)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animating)
        }
        .onAppear {
            animating = true
        }
    }
}

// MARK: - View Extensions
extension View {
    func glitchEffect(isActive: Bool) -> some View {
        modifier(GlitchEffect(isActive: isActive))
    }
    
    func threeDRotation(axis: (x: CGFloat, y: CGFloat, z: CGFloat), perspective: CGFloat = 1) -> some View {
        modifier(ThreeDRotation(axis: axis, perspective: perspective))
    }
    
    func neonGlow(color: Color, radius: CGFloat = 10) -> some View {
        modifier(NeonGlow(color: color, radius: radius))
    }
}

// MARK: - Premium Loading Animation
struct PremiumLoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "FF0080"), Color(hex: "FF8C00")],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 50 + CGFloat(index * 20), height: 50 + CGFloat(index * 20))
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 1)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
                
                Image(systemName: "airplane")
                    .font(.system(size: 30))
                    .foregroundColor(Color(hex: "FF0080"))
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
            }
            
            Text("Loading your adventure...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Matrix Rain Effect
struct MatrixRainEffect: View {
    let columns: Int = 20
    @State private var offsets: [CGFloat] = []
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(0..<columns, id: \.self) { column in
                    MatrixColumn(height: geometry.size.height)
                        .frame(width: geometry.size.width / CGFloat(columns))
                }
            }
        }
    }
}

struct MatrixColumn: View {
    let height: CGFloat
    @State private var offset: CGFloat = 0
    
    let characters = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン0123456789"
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<Int(height / 20), id: \.self) { index in
                Text(String(characters.randomElement() ?? "ア"))
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(hex: "00FF41"))
                    .opacity(Double(index) / Double(height / 20))
            }
        }
        .offset(y: offset)
        .onAppear {
            animateColumn()
        }
    }
    
    private func animateColumn() {
        let duration = Double.random(in: 5...15)
        let delay = Double.random(in: 0...5)
        
        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false).delay(delay)) {
            offset = height * 2
        }
    }
}

#Preview {
    VStack {
        PremiumLoadingView()
            .frame(height: 200)
        
        LiquidGradient(colors: [Color(hex: "FF0080"), Color(hex: "FF8C00"), Color(hex: "0080FF")])
            .frame(height: 200)
            .cornerRadius(20)
            .padding()
    }
}