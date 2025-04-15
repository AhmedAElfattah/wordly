import Foundation

struct QuizQuestion: Identifiable {
    let id = UUID()
    let word: Word
    let correctAnswer: String
    let options: [String]
    var questionType: QuestionType = .termToDefinition
    var question: String = ""

    enum QuestionType {
        case termToDefinition  // Question asks for definition based on term
        case definitionToTerm  // Question asks for term based on definition
    }
}
