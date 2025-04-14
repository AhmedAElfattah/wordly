import SwiftUI
import AVFoundation

// MARK: - Sound Manager
class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayers: [URL: AVAudioPlayer] = [:]
    private var isEnabled = true
    
    private init() {
        // Pre-load sounds
        preloadSounds()
    }
    
    func toggleSound(enabled: Bool) {
        isEnabled = enabled
    }
    
    // MARK: - Sound Playing Methods
    
    func playButtonSound() {
        playSound(named: "button_tap.mp3")
    }
    
    func playSwipeSound() {
        playSound(named: "swipe.mp3")
    }
    
    func playSuccessSound() {
        playSound(named: "success_ding.mp3")
    }
    
    func playVictorySound() {
        playSound(named: "victory.mp3")
    }
    
    func playCorrectAnswerSound() {
        playSound(named: "correct_answer.mp3")
    }
    
    func playWrongAnswerSound() {
        playSound(named: "wrong_answer.mp3")
    }
    
    func playMilestoneSound() {
        playSound(named: "milestone.mp3")
    }
    
    // MARK: - Private Methods
    
    private func preloadSounds() {
        let soundNames = [
            "button_tap.mp3",
            "swipe.mp3",
            "success_ding.mp3",
            "victory.mp3",
            "correct_answer.mp3",
            "wrong_answer.mp3",
            "milestone.mp3"
        ]
        
        for name in soundNames {
            // In a real app, we would load from the bundle
            // For this implementation, we'll simulate the sound loading
            let url = createDummyURL(for: name)
            preloadSound(at: url)
        }
    }
    
    private func createDummyURL(for name: String) -> URL {
        // This is a placeholder since we can't actually create sound files
        // In a real app, we would use Bundle.main.url(forResource:withExtension:)
        return URL(string: "file:///sounds/\(name)")!
    }
    
    private func preloadSound(at url: URL) {
        // In a real app, we would create and prepare the audio player
        // For this implementation, we'll simulate the preloading
        audioPlayers[url] = AVAudioPlayer()
    }
    
    private func playSound(named name: String) {
        guard isEnabled else { return }
        
        let url = createDummyURL(for: name)
        
        // In a real app, we would play the sound
        // For this implementation, we'll simulate playing the sound
        print("Playing sound: \(name)")
    }
}

// MARK: - Haptic Feedback Manager
class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    
    private init() {}
    
    // Basic haptic feedback
    func playSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    // Impact feedback with different intensities
    func playImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    // Notification feedback for success, warning, or error
    func playNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    // Lighter tap for general feedback
    func playLightTap() {
        playImpact(style: .light)
    }
    
    // Medium tap for more significant actions
    func playMediumTap() {
        playImpact(style: .medium)
    }
    
    // Success pattern with lighthearted feel
    func playSuccessPattern() {
        DispatchQueue.main.async {
            self.playImpact(style: .light)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.playImpact(style: .light)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playImpact(style: .medium)
                }
            }
        }
    }
    
    // Error pattern
    func playErrorPattern() {
        DispatchQueue.main.async {
            self.playImpact(style: .medium)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.playImpact(style: .light)
            }
        }
    }
    
    // Milestone achievement pattern
    func playMilestonePattern() {
        DispatchQueue.main.async {
            self.playImpact(style: .light)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.playImpact(style: .light)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    self.playImpact(style: .medium)
                }
            }
        }
    }
    
    // Daily goal completion pattern
    func playDailyGoalPattern() {
        DispatchQueue.main.async {
            self.playImpact(style: .light)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.playImpact(style: .light)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playImpact(style: .light)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.playImpact(style: .medium)
                    }
                }
            }
        }
    }
}
