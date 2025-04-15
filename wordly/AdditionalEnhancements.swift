import SwiftUI

// MARK: - Accessibility Enhancements
struct AccessibilityEnhancements {
    // VoiceOver descriptions for card interactions
    static func cardSwipeDescription(for word: Word) -> String {
        return "Card for word \(word.term). Swipe right to mark as known, swipe left to review later."
    }
    
    // Dynamic font sizing support
    static func dynamicFontSize(for size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight, design: .rounded)
    }
    
    // High contrast mode support
    static func highContrastColor(standard: Color, highContrast: Color, isHighContrast: Bool) -> Color {
        return isHighContrast ? highContrast : standard
    }
}

// MARK: - Motion Reduction Support
struct ReducedMotionCardView: View {
    let word: Word
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Word and pronunciation
            VStack(alignment: .leading, spacing: 4) {
                Text(word.term)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text(word.pronunciation)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                
                Text(word.partOfSpeech)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
            }
            
            // Mastery indicator
          EnhancedMasteryIndicatorView(level: word.masteryLevel)
            
            Divider()
            
            // Definition
            Text(word.definition)
                .font(.body)
                .foregroundColor(.textPrimary)
                .padding(.vertical, 8)
            
            // Example
            Text(word.example)
                .font(.body)
                .italic()
                .foregroundColor(.textSecondary)
                .padding(.bottom, 8)
            
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(AccessibilityEnhancements.cardSwipeDescription(for: word))
    }
}

// MARK: - Enhanced Word Mastery Feature
struct EnhancedMasteryIndicatorView: View {
    let level: MasteryLevel
    @State private var animateProgress = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Mastery: \(level.description)")
                    .font(.caption)
                    .foregroundColor(Color(hex: level.color))
                
                Spacer()
                
                // Visual indicator based on mastery level
                if level == .mastered {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color(hex: level.color))
                        .font(.caption)
                } else if level == .familiar {
                    Image(systemName: "star.leadinghalf.filled")
                        .foregroundColor(Color(hex: level.color))
                        .font(.caption)
                }
            }
            
            // Progress bar with animation
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Rectangle()
                        .frame(width: geometry.size.width, height: 6)
                        .opacity(0.2)
                        .foregroundColor(Color(hex: level.color))
                    
                    // Progress
                    Rectangle()
                        .frame(width: animateProgress ? geometry.size.width * progressPercentage : 0, height: 6)
                        .foregroundColor(Color(hex: level.color))
                }
                .cornerRadius(3)
            }
            .frame(height: 6)
            .onAppear {
                withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.2)) {
                    animateProgress = true
                }
            }
        }
    }
    
    private var progressPercentage: CGFloat {
        let totalLevels = CGFloat(MasteryLevel.allCases.count - 1) // -1 because we start at 0
        let currentLevel = CGFloat(level.rawValue)
        return currentLevel / totalLevels
    }
}

// MARK: - Streak Tracking Feature
class StreakTracker: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var lastInteractionDate: Date?
    
    init() {
        // In a real app, we would load this from UserDefaults
        currentStreak = 1
        bestStreak = 5
        lastInteractionDate = Date()
    }
    
    func recordInteraction() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastDate = lastInteractionDate {
            let lastDay = Calendar.current.startOfDay(for: lastDate)
            
            if today == lastDay {
                // Already recorded today
                return
            }
            
            let components = Calendar.current.dateComponents([.day], from: lastDay, to: today)
            
            if components.day == 1 {
                // Consecutive day
                currentStreak += 1
                if currentStreak > bestStreak {
                    bestStreak = currentStreak
                }
            } else if components.day ?? 0 > 1 {
                // Streak broken
                currentStreak = 1
            }
        }
        
        lastInteractionDate = today
        // In a real app, we would save this to UserDefaults
    }
}

// MARK: - Streak View
struct StreakView: View {
    @ObservedObject var streakTracker: StreakTracker
    
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("\(streakTracker.currentStreak)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Current")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            
            Divider()
                .frame(height: 30)
            
            VStack {
                Text("\(streakTracker.bestStreak)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Best")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}
