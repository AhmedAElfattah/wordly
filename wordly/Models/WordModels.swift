import Foundation

// MARK: - Word Category
enum WordCategory: String, Codable, CaseIterable {
    case everyday = "Everyday"
    case business = "Business"
    case academic = "Academic"
    case technology = "Technology"
    case science = "Science"
    case arts = "Arts"
}

// MARK: - Word
struct Word: Identifiable, Codable, Equatable {
    let id: UUID
    let term: String
    let pronunciation: String
    let partOfSpeech: String
    let definition: String
    let example: String
    let category: WordCategory

    init(
        id: UUID = UUID(),
        term: String,
        pronunciation: String,
        partOfSpeech: String,
        definition: String,
        example: String,
        category: WordCategory
    ) {
        self.id = id
        self.term = term
        self.pronunciation = pronunciation
        self.partOfSpeech = partOfSpeech
        self.definition = definition
        self.example = example
        self.category = category
    }
}

// MARK: - Mastery Level
enum MasteryLevel: Int, CaseIterable {
    case new = 0
    case learning = 1
    case familiar = 2
    case mastered = 3

    var description: String {
        switch self {
        case .new:
            return "New"
        case .learning:
            return "Learning"
        case .familiar:
            return "Familiar"
        case .mastered:
            return "Mastered"
        }
    }

    var color: String {
        switch self {
        case .new:
            return "FF5252"  // Red
        case .learning:
            return "FF9800"  // Orange
        case .familiar:
            return "2196F3"  // Blue
        case .mastered:
            return "4CAF50"  // Green
        }
    }

    func next() -> MasteryLevel {
        let nextRawValue = self.rawValue + 1
        return MasteryLevel(rawValue: nextRawValue) ?? .mastered
    }
}

// MARK: - Difficulty Level
enum DifficultyLevel: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var description: String {
        return self.rawValue
    }
}

// MARK: - User Preferences
struct UserPreferences: Codable {
    var dailyGoal: Int
    var selectedCategories: [WordCategory]

    init(dailyGoal: Int = 5, selectedCategories: [WordCategory] = [.everyday]) {
        self.dailyGoal = dailyGoal
        self.selectedCategories = selectedCategories
    }
}

// MARK: - Quiz Question
struct QuizQuestion {
    let word: Word
    let correctAnswer: String
    let options: [String]
}
