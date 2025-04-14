import Foundation
import SwiftUI
import Combine

final class WordCardViewModel: ObservableObject, Identifiable {
    @Published var words: [Word]
    @Published var currentIndex = 0
    @Published var translation: CGSize = .zero
    @Published var swipeStatus: SwipeStatus = .none
    @Published var wordsViewedToday: Int = 0
    @Published var hasShownDailyGoalAnimation: Bool = false
    @Published var dailyGoal: Int = 10

    private var quizWords: [Word] = []
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

    init(words: [Word] = []) {
        self.words = words
    }

    var currentWord: Word {
        return words[currentIndex]
    }

    func updateSwipeStatus(with translation: CGSize) {
        self.translation = translation

        if translation.height < -50 {
            swipeStatus = .swiping(direction: .up)
        } else if translation.height > 50 {
            swipeStatus = .swiping(direction: .down)
        } else {
            swipeStatus = .none
        }
    }

    func resetSwipe() {
        translation = .zero
        swipeStatus = .none
    }

    func markCurrentWordAsKnown() {
        if !quizWords.contains(where: { $0.id == currentWord.id }) && quizWords.count < 3 {
            quizWords.append(currentWord)
        }
    }

    func incrementWordsViewedToday() {
        wordsViewedToday += 1
    }

    func isDailyGoalReached() -> Bool {
        return wordsViewedToday >= dailyGoal && !hasShownDailyGoalAnimation
    }

    func completedCycle() {
        cycleCount += 1

        if cycleCount > 0 {
            SoundManager.shared.playSuccessSound()
            HapticFeedbackManager.shared.playSuccessPattern()
        }
    }

    func shouldShowQuiz() -> Bool {
        return cycleCount > 0 && quizWords.count >= 3
    }

    func getQuizWords() -> [Word] {
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
        self.words = CategoryWordSets.getWordsForCategories(categories)
    }
}
