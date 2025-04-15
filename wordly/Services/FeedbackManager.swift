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
    
    // Enhanced haptic feedback for word mastery progression
    func playProgressiveHaptic(for masteryLevel: MasteryLevel) {
        switch masteryLevel {
        case .new:
            // Subtle single tap
            playImpact(style: .light)
        case .learning:
            // Double tap with increasing intensity
            DispatchQueue.main.async {
                self.playImpact(style: .light)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playImpact(style: .medium)
                }
            }
        case .familiar:
            // Triple tap pattern
            DispatchQueue.main.async {
                self.playImpact(style: .light)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playImpact(style: .medium)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.playImpact(style: .medium)
                    }
                }
            }
        case .mastered:
            // Success pattern with crescendo
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

    // Enhanced swipe feedback
    func playEnhancedSwipe() {
        // Negative swipe - decrescendo pattern
        DispatchQueue.main.async {
            self.playImpact(style: .medium)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.playImpact(style: .light)
            }
        }
    }

    // Celebration haptic for completing a full cycle
    func playCycleCompletion() {
        DispatchQueue.main.async {
            self.playImpact(style: .medium)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.playImpact(style: .heavy)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    self.playNotification(type: .success)
                }
            }
        }
    }
}

// MARK: - Visual Feedback Manager
class VisualFeedbackManager {
    static let shared = VisualFeedbackManager()
    
    private init() {}
    
    private var isEnabled = true
    
    func toggleFeedback(enabled: Bool) {
        isEnabled = enabled
    }
    
    // MARK: - Feedback Methods
    
    func playButtonFeedback() {
        guard isEnabled else { return }
        // Visual feedback can be implemented in the UI directly
        // This method is kept for API compatibility
    }
    
    func playSwipeFeedback() {
        guard isEnabled else { return }
        // Haptic feedback is handled separately
    }
    
    func playSuccessFeedback() {
        guard isEnabled else { return }
        HapticFeedbackManager.shared.playSuccessPattern()
    }
    
    func playVictoryFeedback() {
        guard isEnabled else { return }
        HapticFeedbackManager.shared.playDailyGoalPattern()
    }
    
    func playCorrectAnswerFeedback() {
        guard isEnabled else { return }
        HapticFeedbackManager.shared.playSuccessPattern()
    }
    
    func playWrongAnswerFeedback() {
        guard isEnabled else { return }
        HapticFeedbackManager.shared.playErrorPattern()
    }
    
    func playMilestoneFeedback() {
        guard isEnabled else { return }
        HapticFeedbackManager.shared.playMilestonePattern()
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
