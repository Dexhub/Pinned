import UIKit
import CoreHaptics

class HapticManager {
    static let shared = HapticManager()
    
    private var hapticEngine: CHHapticEngine?
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let selection = UISelectionFeedbackGenerator()
    private let notification = UINotificationFeedbackGenerator()
    
    private init() {
        prepareHaptics()
    }
    
    private func prepareHaptics() {
        // Prepare standard generators
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        selection.prepare()
        notification.prepare()
        
        // Setup Core Haptics for custom patterns
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Haptic engine failed to start: \(error)")
        }
    }
    
    // MARK: - Standard Haptics
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        switch style {
        case .light:
            impactLight.impactOccurred()
        case .medium:
            impactMedium.impactOccurred()
        case .heavy:
            impactHeavy.impactOccurred()
        default:
            impactMedium.impactOccurred()
        }
    }
    
    func selection() {
        selection.selectionChanged()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notification.notificationOccurred(type)
    }
    
    // MARK: - Custom Haptic Patterns
    
    func playSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            notification(.success)
            return
        }
        
        do {
            let pattern = try successPattern()
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch {
            notification(.success)
        }
    }
    
    func playError() {
        notification(.error)
    }
    
    func playWarning() {
        notification(.warning)
    }
    
    func playCountryAdded() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            notification(.success)
            return
        }
        
        do {
            let pattern = try countryAddedPattern()
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch {
            notification(.success)
        }
    }
    
    func playAchievementUnlocked() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            notification(.success)
            return
        }
        
        do {
            let pattern = try achievementPattern()
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch {
            notification(.success)
        }
    }
    
    // MARK: - Custom Patterns
    
    private func successPattern() throws -> CHHapticPattern {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        
        let event1 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        let event2 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.1)
        
        return try CHHapticPattern(events: [event1, event2], parameters: [])
    }
    
    private func countryAddedPattern() throws -> CHHapticPattern {
        var events: [CHHapticEvent] = []
        
        // Rising intensity pattern
        for i in 0..<3 {
            let intensity = Float(i + 1) * 0.3
            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ],
                relativeTime: Double(i) * 0.1
            )
            events.append(event)
        }
        
        return try CHHapticPattern(events: events, parameters: [])
    }
    
    private func achievementPattern() throws -> CHHapticPattern {
        var events: [CHHapticEvent] = []
        
        // Celebration pattern
        let times: [Double] = [0, 0.1, 0.2, 0.35, 0.5]
        let intensities: [Float] = [0.6, 0.8, 1.0, 0.8, 1.0]
        
        for (index, time) in times.enumerated() {
            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensities[index]),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                ],
                relativeTime: time
            )
            events.append(event)
        }
        
        return try CHHapticPattern(events: events, parameters: [])
    }
}

// MARK: - SwiftUI View Extension

import SwiftUI

extension View {
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle, trigger: Bool) -> some View {
        onChange(of: trigger) { _ in
            if trigger {
                HapticManager.shared.impact(style)
            }
        }
    }
    
    func hapticSelection() -> some View {
        simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    HapticManager.shared.selection()
                }
        )
    }
}