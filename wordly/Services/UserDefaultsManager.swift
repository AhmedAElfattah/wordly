import Foundation
import SwiftUI

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Keys
    private enum Keys {
        static let onboardingCompleted = "onboardingCompleted"
        static let wordsViewedToday = "wordsViewedToday"
        static let lastViewedDate = "lastViewedDate"
        static let streakDays = "streakDays"
        static let bestStreak = "bestStreak"
        static let lastCompletionDate = "lastCompletionDate"
        static let dailyGoal = "dailyGoal"
        static let selectedCategories = "selectedCategories"
        static let masteryLevelPrefix = "masteryLevel_"
    }
    
    // MARK: - Onboarding
    func isOnboardingCompleted() -> Bool {
        return defaults.bool(forKey: Keys.onboardingCompleted)
    }
    
    func setOnboardingCompleted(_ completed: Bool) {
        defaults.set(completed, forKey: Keys.onboardingCompleted)
    }
    
    // MARK: - Daily Goal Tracking
    func getWordsViewedToday() -> Int {
        return defaults.integer(forKey: Keys.wordsViewedToday)
    }
    
    func saveWordsViewedToday(_ count: Int) {
        defaults.set(count, forKey: Keys.wordsViewedToday)
    }
    
    func getLastViewedDate() -> Date? {
        return defaults.object(forKey: Keys.lastViewedDate) as? Date
    }
    
    func saveLastViewedDate(_ date: Date) {
        defaults.set(date, forKey: Keys.lastViewedDate)
    }
    
    // MARK: - Streak Tracking
    func getStreakDays() -> Int {
        return defaults.integer(forKey: Keys.streakDays)
    }
    
    func saveStreakDays(_ days: Int) {
        defaults.set(days, forKey: Keys.streakDays)
    }
    
    func getBestStreak() -> Int {
        return defaults.integer(forKey: Keys.bestStreak)
    }
    
    func saveBestStreak(_ streak: Int) {
        defaults.set(streak, forKey: Keys.bestStreak)
    }
    
    func getLastCompletionDate() -> Date? {
        return defaults.object(forKey: Keys.lastCompletionDate) as? Date
    }
    
    func saveLastCompletionDate(_ date: Date) {
        defaults.set(date, forKey: Keys.lastCompletionDate)
    }
    
    // MARK: - User Preferences
    func getDailyGoal() -> Int {
        let goal = defaults.integer(forKey: Keys.dailyGoal)
        return goal > 0 ? goal : 10 // Default to 10 if not set
    }
    
    func saveDailyGoal(_ goal: Int) {
        defaults.set(goal, forKey: Keys.dailyGoal)
    }
    
    func getSelectedCategories() -> [WordCategory] {
        guard let rawValues = defaults.stringArray(forKey: Keys.selectedCategories) else {
            return [.everyday] // Default to everyday category
        }
        
        return rawValues.compactMap { WordCategory(rawValue: $0) }
    }
    
    func saveSelectedCategories(_ categories: [WordCategory]) {
        let rawValues = categories.map { $0.rawValue }
        defaults.set(rawValues, forKey: Keys.selectedCategories)
    }
    
    // MARK: - Word Mastery Levels
    func getMasteryLevel(for wordId: String) -> MasteryLevel {
        let rawValue = defaults.integer(forKey: Keys.masteryLevelPrefix + wordId)
        return MasteryLevel(rawValue: rawValue) ?? .new
    }
    
    func saveMasteryLevel(for wordId: String, level: MasteryLevel) {
        defaults.set(level.rawValue, forKey: Keys.masteryLevelPrefix + wordId)
    }
    
    // MARK: - Reset
    func resetAllProgress() {
        // Reset UserDefaults but keep onboarding completed
        let wasOnboardingCompleted = isOnboardingCompleted()
        
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
        // Restore onboarding status
        setOnboardingCompleted(wasOnboardingCompleted)
        
        // Set default values
        saveDailyGoal(10)
        saveSelectedCategories([.everyday])
    }
}
