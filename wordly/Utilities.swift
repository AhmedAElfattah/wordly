import SwiftUI

// MARK: - Extensions for UI

extension Color {
    static let background = Color(hex: "121217")
    static let cardBackground = Color(hex: "1E1E24")
    static let primary = Color(hex: "7F5AF0")
    static let secondary = Color(hex: "E45858")
    static let accent = Color(hex: "72F2EB")
    static let textPrimary = Color(hex: "FFFFFE")
    static let textSecondary = Color(hex: "94A1B2")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:  // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Font {
    static let largeTitle = Font.system(size: 40, weight: .bold, design: .default)
    static let title = Font.system(size: 32, weight: .bold, design: .default)
    static let headline = Font.system(size: 24, weight: .semibold, design: .default)
    static let body = Font.system(size: 18, weight: .regular, design: .default)
    static let caption = Font.system(size: 16, weight: .medium, design: .default)
    static let small = Font.system(size: 14, weight: .regular, design: .default)
}

// MARK: - UserDefaults Storage Manager
class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private init() {}

    // UserDefaults keys
    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let difficultyLevel = "difficultyLevel"
        static let selectedCategories = "selectedCategories"
        static let dailyGoal = "dailyGoal"
        static let wordsViewedToday = "wordsViewedToday"
        static let lastViewedDate = "lastViewedDate"
        static let streakDays = "streakDays"
        static let bestStreak = "bestStreak"
        static let lastCompletionDate = "lastCompletionDate"
        static let wordMasteryLevels = "wordMasteryLevels"
    }

    // MARK: - Onboarding and User Preferences

    func setOnboardingCompleted(_ completed: Bool) {
        UserDefaults.standard.set(completed, forKey: Keys.hasCompletedOnboarding)
    }

    func hasCompletedOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.hasCompletedOnboarding)
    }

    func saveDifficultyLevel(_ level: DifficultyLevel) {
        UserDefaults.standard.set(level.rawValue, forKey: Keys.difficultyLevel)
    }

    func getDifficultyLevel() -> DifficultyLevel {
        let levelString =
            UserDefaults.standard.string(forKey: Keys.difficultyLevel)
            ?? DifficultyLevel.intermediate.rawValue
        return DifficultyLevel(rawValue: levelString) ?? .intermediate
    }

    func saveSelectedCategories(_ categories: [WordCategory]) {
        let categoryStrings = categories.map { $0.rawValue }
        UserDefaults.standard.set(categoryStrings, forKey: Keys.selectedCategories)
    }

    func getSelectedCategories() -> [WordCategory] {
        guard
            let categoryStrings = UserDefaults.standard.stringArray(forKey: Keys.selectedCategories)
        else {
            return [.everyday]  // Default category
        }

        return categoryStrings.compactMap { WordCategory(rawValue: $0) }
    }

    func saveDailyGoal(_ goal: Int) {
        UserDefaults.standard.set(goal, forKey: Keys.dailyGoal)
    }

    func getDailyGoal() -> Int {
        return UserDefaults.standard.integer(forKey: Keys.dailyGoal).nonZero ?? 10  // Default to 10 if not set or zero
    }

    // MARK: - Daily Progress Tracking

    func saveWordsViewedToday(_ count: Int) {
        UserDefaults.standard.set(count, forKey: Keys.wordsViewedToday)
    }

    func getWordsViewedToday() -> Int {
        // Check if we need to reset for a new day
        if !isSameDay() {
            saveWordsViewedToday(0)
            saveLastViewedDate(Date())
            return 0
        }

        return UserDefaults.standard.integer(forKey: Keys.wordsViewedToday)
    }

    func saveLastViewedDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: Keys.lastViewedDate)
    }

    func getLastViewedDate() -> Date? {
        return UserDefaults.standard.object(forKey: Keys.lastViewedDate) as? Date
    }

    private func isSameDay() -> Bool {
        guard let lastDate = getLastViewedDate() else {
            return false
        }

        let calendar = Calendar.current
        return calendar.isDate(lastDate, inSameDayAs: Date())
    }

    // MARK: - Streak Tracking

    func saveStreakDays(_ days: Int) {
        UserDefaults.standard.set(days, forKey: Keys.streakDays)
    }

    func getStreakDays() -> Int {
        return UserDefaults.standard.integer(forKey: Keys.streakDays)
    }

    func saveBestStreak(_ days: Int) {
        UserDefaults.standard.set(days, forKey: Keys.bestStreak)
    }

    func getBestStreak() -> Int {
        return UserDefaults.standard.integer(forKey: Keys.bestStreak)
    }

    func saveLastCompletionDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: Keys.lastCompletionDate)
    }

    func getLastCompletionDate() -> Date? {
        return UserDefaults.standard.object(forKey: Keys.lastCompletionDate) as? Date
    }

    // MARK: - Word Mastery Levels

    func saveMasteryLevel(for wordId: String, level: MasteryLevel) {
        var masteryLevels = getMasteryLevels()
        masteryLevels[wordId] = level.rawValue
        UserDefaults.standard.set(masteryLevels, forKey: Keys.wordMasteryLevels)
    }

    func getMasteryLevel(for wordId: String) -> MasteryLevel {
        let masteryLevels = getMasteryLevels()
        let levelRaw = masteryLevels[wordId] ?? MasteryLevel.new.rawValue
        return MasteryLevel(rawValue: levelRaw) ?? .new
    }

    private func getMasteryLevels() -> [String: Int] {
        return UserDefaults.standard.dictionary(forKey: Keys.wordMasteryLevels) as? [String: Int]
            ?? [:]
    }
}

// MARK: - Extensions

extension Int {
    var nonZero: Int {
        return self == 0 ? 10 : self
    }
}

// Custom notification names
extension Notification.Name {
    static let wordCardSwiped = Notification.Name("wordCardSwiped")
}
