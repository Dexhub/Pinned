import AVFoundation
import SwiftUI

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    @AppStorage("soundEnabled") private var soundEnabled = true
    @AppStorage("soundVolume") private var soundVolume: Double = 0.7
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    // Sound effect names
    enum Sound: String {
        case tap = "tap"
        case success = "success"
        case error = "error"
        case countryAdded = "country_added"
        case achievementUnlocked = "achievement_unlocked"
        case swipe = "swipe"
        case pop = "pop"
        case celebration = "celebration"
        case quiz = "quiz"
        case share = "share"
    }
    
    private init() {
        setupAudioSession()
        preloadSounds()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func preloadSounds() {
        // Since we don't have actual sound files, we'll use system sounds
        // In a real app, you would load custom sound files here
    }
    
    func play(_ sound: Sound) {
        guard soundEnabled else { return }
        
        // Play system sounds based on the sound type
        switch sound {
        case .tap:
            playSystemSound(1104) // Keyboard tap
        case .success:
            playSystemSound(1025) // Success sound
        case .error:
            playSystemSound(1053) // Error sound
        case .countryAdded:
            playSystemSound(1022) // Positive sound
        case .achievementUnlocked:
            playSystemSound(1025) // Achievement sound
        case .swipe:
            playSystemSound(1104) // Light tap
        case .pop:
            playSystemSound(1306) // Pop sound
        case .celebration:
            playSystemSound(1025) // Celebration
        case .quiz:
            playSystemSound(1103) // Quiz sound
        case .share:
            playSystemSound(1022) // Share sound
        }
    }
    
    private func playSystemSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }
    
    func playCustomSound(named fileName: String, ofType type: String = "mp3") {
        guard soundEnabled,
              let url = Bundle.main.url(forResource: fileName, withExtension: type) else { return }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = Float(soundVolume)
            player.prepareToPlay()
            player.play()
            audioPlayers[fileName] = player
        } catch {
            print("Failed to play sound \(fileName): \(error)")
        }
    }
    
    func stopAll() {
        audioPlayers.values.forEach { $0.stop() }
        audioPlayers.removeAll()
    }
    
    func setVolume(_ volume: Double) {
        soundVolume = volume
        audioPlayers.values.forEach { $0.volume = Float(volume) }
    }
    
    func toggleSound() {
        soundEnabled.toggle()
        if !soundEnabled {
            stopAll()
        }
    }
}

// MARK: - SwiftUI View Extension

extension View {
    func playSound(_ sound: SoundManager.Sound, trigger: Bool) -> some View {
        onChange(of: trigger) { _ in
            if trigger {
                SoundManager.shared.play(sound)
            }
        }
    }
    
    func playSoundOnTap(_ sound: SoundManager.Sound) -> some View {
        simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    SoundManager.shared.play(sound)
                }
        )
    }
}