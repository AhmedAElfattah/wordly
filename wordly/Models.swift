import Foundation
import SwiftUI

// MARK: - Models

struct Word: Identifiable, Equatable {
    let id = UUID()
    let term: String
    let pronunciation: String
    let partOfSpeech: String
    let definition: String
    let example: String
    let category: WordCategory
    var masteryLevel: MasteryLevel = .new
}

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
            return "#666666"  // Gray
        case .learning:
            return "#3A7D44"  // Green
        case .familiar:
            return "#FFD166"  // Yellow
        case .mastered:
            return "#FF6B6B"  // Red
        }
    }

    func next() -> MasteryLevel {
        let nextRawValue = self.rawValue + 1
        return MasteryLevel(rawValue: nextRawValue) ?? .mastered
    }
}

enum DifficultyLevel: String, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var id: String { self.rawValue }

    var description: String {
        switch self {
        case .beginner:
            return "Perfect for those new to vocabulary building"
        case .intermediate:
            return "Expand your existing vocabulary"
        case .advanced:
            return "Challenge yourself with complex words"
        }
    }
}

enum WordCategory: String, CaseIterable, Identifiable {
    case science = "Science"
    case business = "Business"
    case arts = "Arts"
    case technology = "Technology"
    case academic = "Academic"
    case everyday = "Everyday"

    var id: String { self.rawValue }

    static var allCases: [WordCategory] {
        return [.science, .business, .arts, .technology, .academic, .everyday]
    }
}

// MARK: - Quiz Question
struct QuizQuestion: Identifiable {
    let id = UUID()
    let word: Word
    let correctAnswer: String
    let options: [String]
}
