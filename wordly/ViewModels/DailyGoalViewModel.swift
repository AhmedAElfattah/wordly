import Combine
import SwiftUI

final class DailyGoalViewModel: ObservableObject {
    @Published var wordsViewedToday: Int = 0 {
        didSet {
            // Save progress whenever wordsViewedToday changes directly
            UserDefaultsManager.shared.saveWordsViewedToday(wordsViewedToday)

            // Update goal reached status
            if wordsViewedToday >= dailyGoal && !hasReachedGoalToday {
                hasReachedGoalToday = true
                lastCompletionDate = Date()
                updateStreak()
                UserDefaultsManager.shared.saveLastCompletionDate(lastCompletionDate!)
            }
        }
    }
    @Published var dailyGoal: Int = 10
    @Published var hasReachedGoalToday: Bool = false
    @Published var streakDays: Int = 0
    @Published var bestStreak: Int = 0
    @Published var lastCompletionDate: Date?

    private var cancellables = Set<AnyCancellable>()

    init(dailyGoal: Int = 10) {
        self.dailyGoal = dailyGoal
        loadSavedProgress()

        // Set up notification to observe user defaults changes
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                self?.refreshWordsViewed()
            }
            .store(in: &cancellables)

        // Listen for direct swipe notifications
        NotificationCenter.default.publisher(for: .wordCardSwiped)
            .sink { [weak self] _ in
                self?.refreshWordsViewed()
            }
            .store(in: &cancellables)
    }

    // Refresh the word count from UserDefaults
    private func refreshWordsViewed() {
        let count = UserDefaultsManager.shared.getWordsViewedToday()
        if count != wordsViewedToday {
            DispatchQueue.main.async {
                self.wordsViewedToday = count
            }
        }
    }

    // Load saved progress from UserDefaults
    private func loadSavedProgress() {
        wordsViewedToday = UserDefaultsManager.shared.getWordsViewedToday()
        streakDays = UserDefaultsManager.shared.getStreakDays()
        bestStreak = UserDefaultsManager.shared.getBestStreak()
        lastCompletionDate = UserDefaultsManager.shared.getLastCompletionDate()

        // Check if daily goal was reached today
        hasReachedGoalToday = wordsViewedToday >= dailyGoal

        // If it's a new day, check if streak needs to be updated
        if let lastDate = lastCompletionDate {
            let calendar = Calendar.current
            let lastDay = calendar.startOfDay(for: lastDate)
            let today = calendar.startOfDay(for: Date())

            if !calendar.isDate(lastDay, inSameDayAs: today) {
                // It's a new day, reset daily goal tracking
                resetDailyProgress()
            }
        }
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

        // Save streak data
        UserDefaultsManager.shared.saveStreakDays(streakDays)
        UserDefaultsManager.shared.saveBestStreak(bestStreak)
    }

    // Reset daily progress (called at the start of a new day)
    func resetDailyProgress() {
        wordsViewedToday = 0
        hasReachedGoalToday = false
        UserDefaultsManager.shared.saveWordsViewedToday(0)
        UserDefaultsManager.shared.saveLastViewedDate(Date())
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

// MARK: - Notification Extensions
extension Notification.Name {
    static let wordCardSwiped = Notification.Name("wordCardSwiped")
}
