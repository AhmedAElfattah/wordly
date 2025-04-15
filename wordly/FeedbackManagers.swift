import AVFoundation
import SwiftUI

// MARK: - Haptic Feedback Manager
class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()

    private init() {}

    enum ImpactStyle {
        case light
        case medium
        case heavy
    }

    enum NotificationType {
        case success
        case warning
        case error
    }

    func playImpact(style: ImpactStyle) {
        let generator = UIImpactFeedbackGenerator(style: style.feedbackStyle)
        generator.impactOccurred()
    }

    func playNotification(type: NotificationType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type.feedbackType)
    }

    func playSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    // Enhanced haptic feedback patterns
    func playMilestonePattern() {
        DispatchQueue.main.async {
            self.playImpact(style: .light)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.playImpact(style: .medium)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playNotification(type: .success)
                }
            }
        }
    }

    func playSuccessPattern() {
        DispatchQueue.main.async {
            self.playImpact(style: .medium)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.playNotification(type: .success)
            }
        }
    }

    func playErrorPattern() {
        DispatchQueue.main.async {
            self.playImpact(style: .heavy)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.playNotification(type: .error)
            }
        }
    }

    func playDailyGoalPattern() {
        DispatchQueue.main.async {
            self.playImpact(style: .light)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.playImpact(style: .medium)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playImpact(style: .heavy)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.playNotification(type: .success)
                    }
                }
            }
        }
    }
}

// MARK: - Sound Manager
class SoundManager {
    static let shared = SoundManager()

    private var audioPlayers: [URL: AVAudioPlayer] = [:]
    private var isEnabled = true

    private init() {
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
            "milestone.mp3",
        ]

        for name in soundNames {
            let url = createDummyURL(for: name)
            preloadSound(at: url)
        }
    }

    private func createDummyURL(for name: String) -> URL {
        return URL(string: "file:///sounds/\(name)")!
    }

    private func preloadSound(at url: URL) {
        // In a real app, we would load from the bundle
        // For this implementation, we'll simulate the sound loading
        print("Preloading sound: \(url.lastPathComponent)")
    }

    private func playSound(named name: String) {
        guard isEnabled else { return }

        let url = createDummyURL(for: name)
        print("Playing sound: \(name)")
    }
}

// MARK: - Extensions
extension HapticFeedbackManager.ImpactStyle {
    var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .light: return .light
        case .medium: return .medium
        case .heavy: return .heavy
        }
    }
}

extension HapticFeedbackManager.NotificationType {
    var feedbackType: UINotificationFeedbackGenerator.FeedbackType {
        switch self {
        case .success: return .success
        case .warning: return .warning
        case .error: return .error
        }
    }
}
