import Combine
import SwiftUI

class WordCardViewModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var words: [Word]
    @Published var translation: CGSize = .zero
    @Published var swipeStatus: SwipeStatus = .none
    @Published var wordsViewedToday: Int = 0
    @Published var hasShownDailyGoalAnimation: Bool = false
    @Published var quizWords: [Word] = []

    var dailyGoal = 10
    private var cycleCount = 0

    enum SwipeStatus {
        case none
        case swiping(direction: SwipeDirection)
        case swiped(direction: SwipeDirection)
    }

    enum SwipeDirection {
        case up
        case down
        case left
        case right
    }

    init(words: [Word]) {
        self.words = words
        loadSavedProgress()
    }

    var currentWord: Word {
        return words[currentIndex]
    }

    private func loadSavedProgress() {
        // In a real app, we would load this from UserDefaults
        wordsViewedToday = 0
        hasShownDailyGoalAnimation = false
    }

    private func saveProgress() {
        // In a real app, we would save this to UserDefaults
        print("Saving progress: \(wordsViewedToday)/\(dailyGoal) words viewed today")
    }

    func markCurrentWordAsKnown() {
        // Update mastery level when swiping up (marking as known)
        if words[currentIndex].masteryLevel != .mastered {
            let oldLevel = words[currentIndex].masteryLevel
            let newLevel = oldLevel.next()

            // Update the word's mastery level
            words[currentIndex].masteryLevel = newLevel

            // Play haptic feedback and sound if level increased
            if newLevel.rawValue > oldLevel.rawValue {
                HapticFeedbackManager.shared.playMilestonePattern()
                SoundManager.shared.playMilestoneSound()
            }
        }

        // Add to quiz words if not already included
        if !quizWords.contains(where: { $0.id == currentWord.id }) && quizWords.count < 5 {
            quizWords.append(currentWord)
        }
    }

    func incrementWordsViewedToday() {
        wordsViewedToday += 1
        saveProgress()
    }

    func isDailyGoalReached() -> Bool {
        return wordsViewedToday >= dailyGoal && !hasShownDailyGoalAnimation
    }

    func completedCycle() {
        cycleCount += 1
        hasShownDailyGoalAnimation = false
    }

    func shouldShowQuiz() -> Bool {
        // Show quiz after completing at least one cycle and having enough quiz words
        return cycleCount > 0 && quizWords.count >= 3
    }

    func getQuizWords() -> [Word] {
        // Return collected quiz words, or random words if not enough
        if quizWords.count >= 3 {
            return Array(quizWords.prefix(3))
        } else {
            var result = quizWords
            while result.count < 3 {
                if let randomWord = words.randomElement(),
                    !result.contains(where: { $0.id == randomWord.id })
                {
                    result.append(randomWord)
                }
            }
            return result
        }
    }

    func resetToFirstWord() {
        currentIndex = 0
    }

    func loadWordsForCategories(_ categories: [WordCategory]) {
        // In a real app, we would load this from a database
        words = Word.sampleWords.filter { word in
            categories.contains(word.category)
        }
        currentIndex = 0
        wordsViewedToday = 0
        hasShownDailyGoalAnimation = false
    }
}
