import Combine
import Foundation
import SwiftUI

class WordCardViewModel: ObservableObject {
    @Published var currentIndex = 0
    @Published var words: [Word]
    @Published var translation: CGSize = .zero
    @Published var swipeStatus: SwipeStatus = .none
    @Published var wordsViewedToday: Int = 0
    @Published var hasShownDailyGoalAnimation: Bool = false

    var dailyGoal = 10
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

    init(words: [Word]) {
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

        // Play sound and haptic feedback for completing a cycle
        if cycleCount > 0 {
            SoundManager.shared.playSuccessSound()
            HapticFeedbackManager.shared.playSuccessPattern()
        }
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
        words = CategoryWordSets.getWordsForCategories(categories)
    }
}

class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion]
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswer: String?
    @Published var isAnswerCorrect: Bool?
    @Published var score = 0
    @Published var isQuizComplete = false

    var currentQuestion: QuizQuestion {
        questions[currentQuestionIndex]
    }

    var isPassed: Bool {
        // Pass if score is at least 70%
        let passingScore = Int(Double(questions.count) * 0.7)
        return score >= passingScore
    }

    init(words: [Word]) {
        // Create quiz questions from words
        self.questions = words.map { word in
            QuizQuestion(
                word: word,
                correctAnswer: word.term,
                options: Self.generateOptions(correctWord: word, allWords: words)
            )
        }

        // Limit to 5 questions maximum
        if questions.count > 5 {
            questions = Array(questions.prefix(5))
        }
    }

    func selectAnswer(_ answer: String) {
        selectedAnswer = answer
        isAnswerCorrect = answer == currentQuestion.correctAnswer

        if isAnswerCorrect == true {
            score += 1
            SoundManager.shared.playCorrectAnswerSound()
            HapticFeedbackManager.shared.playSuccessPattern()
        } else {
            SoundManager.shared.playWrongAnswerSound()
            HapticFeedbackManager.shared.playErrorPattern()
        }
    }

    func moveToNextQuestion() {
        // Reset for next question
        selectedAnswer = nil
        isAnswerCorrect = nil

        // Move to next question or complete quiz
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            isQuizComplete = true
        }
    }

    private static func generateOptions(correctWord: Word, allWords: [Word]) -> [String] {
        var options = [correctWord.term]

        // Add other terms as options
        while options.count < 4 {
            if let randomWord = allWords.randomElement(), !options.contains(randomWord.term) {
                options.append(randomWord.term)
            }
        }

        // Shuffle options
        return options.shuffled()
    }
}

class EnhancedOnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var selectedDifficulty: DifficultyLevel = .intermediate
    @Published var selectedCategories: Set<WordCategory> = []
    @Published var selectedDailyGoal: Int = 10

    enum OnboardingStep {
        case welcome
        case difficultySelection
        case categorySelection
        case dailyGoalSetting
        case completion
    }

    func moveToNextStep() {
        switch currentStep {
        case .welcome:
            currentStep = .difficultySelection
        case .difficultySelection:
            currentStep = .categorySelection
        case .categorySelection:
            currentStep = .dailyGoalSetting
        case .dailyGoalSetting:
            currentStep = .completion
        case .completion:
            break
        }
    }

    func moveToPreviousStep() {
        switch currentStep {
        case .welcome:
            break
        case .difficultySelection:
            currentStep = .welcome
        case .categorySelection:
            currentStep = .difficultySelection
        case .dailyGoalSetting:
            currentStep = .categorySelection
        case .completion:
            currentStep = .dailyGoalSetting
        }
    }

    func selectDifficulty(_ difficulty: DifficultyLevel) {
        selectedDifficulty = difficulty
    }

    func toggleCategory(_ category: WordCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }

    func isCategorySelected(_ category: WordCategory) -> Bool {
        return selectedCategories.contains(category)
    }

    func canProceedFromCategorySelection() -> Bool {
        return !selectedCategories.isEmpty
    }

    func getUserPreferences() -> UserPreferences {
        return UserPreferences(
            dailyGoal: selectedDailyGoal,
            selectedCategories: Array(selectedCategories)
        )
    }
}

class DailyGoalTracker: ObservableObject {
    @Published var wordsViewedToday: Int = 0
    @Published var dailyGoal: Int = 10
    @Published var hasReachedGoalToday: Bool = false
    @Published var streakDays: Int = 0
    @Published var bestStreak: Int = 0
    @Published var lastCompletionDate: Date?

    init(dailyGoal: Int = 10) {
        self.dailyGoal = dailyGoal
        loadSavedProgress()
    }

    // Load saved progress (in a real app, this would use UserDefaults or CoreData)
    private func loadSavedProgress() {
        // Simulate loading from persistent storage
        wordsViewedToday = 0
        streakDays = 1
        bestStreak = 5
        hasReachedGoalToday = false
        lastCompletionDate = nil
    }

    // Save progress (in a real app, this would use UserDefaults or CoreData)
    private func saveProgress() {
        // Simulate saving to persistent storage
        print("Saving progress: \(wordsViewedToday)/\(dailyGoal) words, streak: \(streakDays) days")
    }

    // Record a viewed word
    func recordWordViewed() {
        wordsViewedToday += 1

        // Check if daily goal is reached
        if wordsViewedToday >= dailyGoal && !hasReachedGoalToday {
            hasReachedGoalToday = true
            lastCompletionDate = Date()
            updateStreak()
        }

        saveProgress()
    }

    // Update streak based on completion dates
    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())

        if let lastDate = lastCompletionDate {
            let lastDay = Calendar.current.startOfDay(for: lastDate)

            // Check if this is a new day
            if today != lastDay {
                let components = Calendar.current.dateComponents([.day], from: lastDay, to: today)

                if components.day == 1 {
                    // Consecutive day
                    streakDays += 1
                    if streakDays > bestStreak {
                        bestStreak = streakDays
                    }
                } else if components.day ?? 0 > 1 {
                    // Streak broken
                    streakDays = 1
                }
            }
        }

        saveProgress()
    }

    // Reset daily progress (called at the start of a new day)
    func resetDailyProgress() {
        wordsViewedToday = 0
        hasReachedGoalToday = false
        saveProgress()
    }

    // Check if daily goal is reached
    func isDailyGoalReached() -> Bool {
        return wordsViewedToday >= dailyGoal
    }

    // Get progress percentage
    func getProgressPercentage() -> Double {
        return min(Double(wordsViewedToday) / Double(dailyGoal), 1.0)
    }
}

struct DailyProgress: Codable {
    var wordsViewedToday: Int
    var streakDays: Int
    var bestStreak: Int
    var hasReachedGoalToday: Bool
    var lastCompletionDate: Date?
}
