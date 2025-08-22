import SwiftUI

struct CoachMark: Identifiable {
    let id = UUID()
    let targetId: String
    let title: String
    let description: String
    let position: CoachMarkPosition
    let dismissOnTap: Bool
    
    enum CoachMarkPosition {
        case above, below, left, right
    }
}

class CoachMarksManager: ObservableObject {
    @Published var currentCoachMarks: [CoachMark] = []
    @Published var currentMarkIndex: Int = 0
    @Published var isShowingCoachMarks: Bool = false
    
    @AppStorage("hasSeenMapCoachMarks") private var hasSeenMapCoachMarks = false
    @AppStorage("hasSeenStatsCoachMarks") private var hasSeenStatsCoachMarks = false
    @AppStorage("hasSeenProfileCoachMarks") private var hasSeenProfileCoachMarks = false
    
    static let shared = CoachMarksManager()
    
    // Define coach marks for different screens
    let mapCoachMarks = [
        CoachMark(
            targetId: "search_bar",
            title: "Search Countries",
            description: "Type any country or city name to add it to your map",
            position: .below,
            dismissOnTap: true
        ),
        CoachMark(
            targetId: "world_percentage",
            title: "Track Your Progress",
            description: "See what percentage of the world you've explored",
            position: .below,
            dismissOnTap: true
        ),
        CoachMark(
            targetId: "add_button",
            title: "Add Detailed Records",
            description: "Tap here to add comprehensive travel records with photos",
            position: .above,
            dismissOnTap: true
        )
    ]
    
    let statsCoachMarks = [
        CoachMark(
            targetId: "stats_header",
            title: "Your Travel Stats",
            description: "See detailed analytics about your travel patterns",
            position: .below,
            dismissOnTap: true
        ),
        CoachMark(
            targetId: "achievement_progress",
            title: "Unlock Achievements",
            description: "Complete travel milestones to earn achievements",
            position: .below,
            dismissOnTap: true
        )
    ]
    
    func showMapCoachMarks() {
        guard !hasSeenMapCoachMarks else { return }
        currentCoachMarks = mapCoachMarks
        currentMarkIndex = 0
        isShowingCoachMarks = true
    }
    
    func showStatsCoachMarks() {
        guard !hasSeenStatsCoachMarks else { return }
        currentCoachMarks = statsCoachMarks
        currentMarkIndex = 0
        isShowingCoachMarks = true
    }
    
    func nextCoachMark() {
        HapticManager.shared.selection()
        
        if currentMarkIndex < currentCoachMarks.count - 1 {
            withAnimation(.spring()) {
                currentMarkIndex += 1
            }
        } else {
            dismissCoachMarks()
        }
    }
    
    func dismissCoachMarks() {
        HapticManager.shared.impact(.light)
        
        withAnimation(.spring()) {
            isShowingCoachMarks = false
        }
        
        // Mark as seen based on current marks
        if currentCoachMarks == mapCoachMarks {
            hasSeenMapCoachMarks = true
        } else if currentCoachMarks == statsCoachMarks {
            hasSeenStatsCoachMarks = true
        }
        
        currentCoachMarks = []
        currentMarkIndex = 0
    }
    
    func resetAllCoachMarks() {
        hasSeenMapCoachMarks = false
        hasSeenStatsCoachMarks = false
        hasSeenProfileCoachMarks = false
    }
}

struct CoachMarksOverlay: View {
    @ObservedObject var manager = CoachMarksManager.shared
    @State private var targetFrames: [String: CGRect] = [:]
    @Namespace private var animation
    
    var body: some View {
        if manager.isShowingCoachMarks && manager.currentMarkIndex < manager.currentCoachMarks.count {
            let currentMark = manager.currentCoachMarks[manager.currentMarkIndex]
            
            ZStack {
                // Dark overlay with cutout
                CoachMarkCutoutView(
                    targetFrame: targetFrames[currentMark.targetId] ?? .zero
                )
                .ignoresSafeArea()
                .onTapGesture {
                    if currentMark.dismissOnTap {
                        manager.nextCoachMark()
                    }
                }
                
                // Coach mark bubble
                if let targetFrame = targetFrames[currentMark.targetId] {
                    CoachMarkBubble(
                        mark: currentMark,
                        targetFrame: targetFrame,
                        onNext: { manager.nextCoachMark() },
                        onSkip: { manager.dismissCoachMarks() },
                        currentIndex: manager.currentMarkIndex,
                        totalCount: manager.currentCoachMarks.count
                    )
                    .matchedGeometryEffect(id: "coachmark", in: animation)
                }
            }
            .transition(.opacity)
        }
    }
    
    func registerFrame(for id: String, frame: CGRect) {
        targetFrames[id] = frame
    }
}

struct CoachMarkCutoutView: View {
    let targetFrame: CGRect
    @State private var animateHighlight = false
    
    var body: some View {
        ZStack {
            // Full screen dark overlay
            Color.black.opacity(0.75)
            
            // Cutout for target
            if targetFrame != .zero {
                RoundedRectangle(cornerRadius: 12)
                    .frame(
                        width: targetFrame.width + 20,
                        height: targetFrame.height + 20
                    )
                    .position(
                        x: targetFrame.midX,
                        y: targetFrame.midY
                    )
                    .blendMode(.destinationOut)
                
                // Animated highlight border
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 3)
                    .frame(
                        width: targetFrame.width + 20,
                        height: targetFrame.height + 20
                    )
                    .position(
                        x: targetFrame.midX,
                        y: targetFrame.midY
                    )
                    .scaleEffect(animateHighlight ? 1.1 : 1.0)
                    .opacity(animateHighlight ? 0 : 1)
                    .animation(.easeInOut(duration: 1.5).repeatForever(), value: animateHighlight)
                    .onAppear { animateHighlight = true }
            }
        }
        .compositingGroup()
    }
}

struct CoachMarkBubble: View {
    let mark: CoachMark
    let targetFrame: CGRect
    let onNext: () -> Void
    let onSkip: () -> Void
    let currentIndex: Int
    let totalCount: Int
    
    @State private var isAnimating = false
    
    var bubblePosition: CGPoint {
        switch mark.position {
        case .above:
            return CGPoint(x: targetFrame.midX, y: targetFrame.minY - 120)
        case .below:
            return CGPoint(x: targetFrame.midX, y: targetFrame.maxY + 120)
        case .left:
            return CGPoint(x: targetFrame.minX - 150, y: targetFrame.midY)
        case .right:
            return CGPoint(x: targetFrame.maxX + 150, y: targetFrame.midY)
        }
    }
    
    var arrowRotation: Double {
        switch mark.position {
        case .above: return 180
        case .below: return 0
        case .left: return 90
        case .right: return -90
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Arrow pointing to target
            if mark.position == .below {
                Triangle()
                    .fill(Color.white)
                    .frame(width: 20, height: 10)
                    .rotationEffect(.degrees(arrowRotation))
                    .offset(y: 1)
            }
            
            // Bubble content
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text(mark.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(mark.description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<totalCount, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color(hex: "FF0080") : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                
                // Actions
                HStack(spacing: 16) {
                    if currentIndex < totalCount - 1 {
                        Button("Skip") {
                            onSkip()
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    }
                    
                    Button(currentIndex < totalCount - 1 ? "Next" : "Got it!") {
                        onNext()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color(hex: "FF0080"))
                    .cornerRadius(25)
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 20)
            
            // Arrow pointing to target
            if mark.position == .above {
                Triangle()
                    .fill(Color.white)
                    .frame(width: 20, height: 10)
                    .rotationEffect(.degrees(arrowRotation))
                    .offset(y: -1)
            }
        }
        .frame(width: 280)
        .position(bubblePosition)
        .scaleEffect(isAnimating ? 1 : 0.8)
        .opacity(isAnimating ? 1 : 0)
        .onAppear {
            withAnimation(.spring()) {
                isAnimating = true
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - View Extension for Coach Marks

struct CoachMarkModifier: ViewModifier {
    let id: String
    @State private var frame: CGRect = .zero
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: FramePreferenceKey.self, value: geometry.frame(in: .global))
                }
            )
            .onPreferenceChange(FramePreferenceKey.self) { newFrame in
                frame = newFrame
                NotificationCenter.default.post(
                    name: .coachMarkFrameChanged,
                    object: nil,
                    userInfo: ["id": id, "frame": newFrame]
                )
            }
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    func coachMark(id: String) -> some View {
        modifier(CoachMarkModifier(id: id))
    }
}

extension Notification.Name {
    static let coachMarkFrameChanged = Notification.Name("coachMarkFrameChanged")
}

#Preview {
    ZStack {
        VStack {
            Text("Sample View")
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .coachMark(id: "sample")
        }
        
        CoachMarksOverlay()
    }
    .onAppear {
        CoachMarksManager.shared.currentCoachMarks = [
            CoachMark(
                targetId: "sample",
                title: "Welcome!",
                description: "This is a sample coach mark",
                position: .below,
                dismissOnTap: true
            )
        ]
        CoachMarksManager.shared.isShowingCoachMarks = true
    }
}