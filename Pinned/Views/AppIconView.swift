import SwiftUI

struct AppIconView: View {
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [Color(hex: "FF0080"), Color(hex: "0080FF")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Map Pin Icon
            ZStack {
                // Pin Body
                Circle()
                    .fill(Color.white)
                    .frame(width: 180, height: 180)
                
                // Inner circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FF0080"), Color(hex: "FF4080")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 140, height: 140)
                
                // World map pattern
                ZStack {
                    ForEach(0..<6) { index in
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(
                                width: CGFloat.random(in: 20...40),
                                height: CGFloat.random(in: 20...40)
                            )
                            .offset(
                                x: CGFloat.random(in: -40...40),
                                y: CGFloat.random(in: -40...40)
                            )
                    }
                }
                .clipShape(Circle())
                .frame(width: 140, height: 140)
                
                // Pin tip
                Path { path in
                    path.move(to: CGPoint(x: 100, y: 180))
                    path.addLine(to: CGPoint(x: 140, y: 140))
                    path.addLine(to: CGPoint(x: 160, y: 140))
                    path.closeSubpath()
                }
                .fill(Color.white)
                .offset(y: 40)
            }
        }
        .frame(width: 300, height: 300)
        .cornerRadius(60)
    }
}

// Helper to export icon at different sizes
struct AppIconExporter: View {
    let sizes = [
        (20, 2), (20, 3),
        (29, 2), (29, 3),
        (40, 2), (40, 3),
        (60, 2), (60, 3),
        (1024, 1)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(sizes, id: \.0) { size, scale in
                    VStack {
                        Text("@\(scale)x - \(size * scale)pt")
                            .font(.caption)
                        
                        AppIconView()
                            .frame(
                                width: CGFloat(size * scale),
                                height: CGFloat(size * scale)
                            )
                            .background(Color.gray.opacity(0.1))
                            .border(Color.gray, width: 1)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    VStack {
        AppIconView()
            .frame(width: 200, height: 200)
        
        Text("Pinned")
            .font(.system(size: 32, weight: .bold))
            .padding()
    }
}