import Foundation

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
