import Combine
import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var questions: [QuizQuestion] = []
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswer: String? = nil
    @Published var isAnswerCorrect: Bool? = nil
    @Published var score = 0
    @Published var isQuizComplete = false
    
    private var words: [Word]
    
    init(words: [Word]) {
        self.words = words
    }
    
    var currentQuestion: QuizQuestion {
        questions[currentQuestionIndex]
    }
    
    var isPassed: Bool {
        let percentage = Double(score) / Double(questions.count)
        return percentage >= 0.7 // 70% or higher to pass
    }
    
    func startQuiz(with words: [Word]) {
        // Generate questions from the provided words
        questions = generateQuestions(from: words)
        currentQuestionIndex = 0
        selectedAnswer = nil
        isAnswerCorrect = nil
        score = 0
        isQuizComplete = false
    }
    
    func selectAnswer(_ answer: String) {
        selectedAnswer = answer
        isAnswerCorrect = (answer == currentQuestion.correctAnswer)
        
        if isAnswerCorrect == true {
            score += 1
            VisualFeedbackManager.shared.playCorrectAnswerFeedback()
            HapticFeedbackManager.shared.playSuccessPattern()
        } else {
            VisualFeedbackManager.shared.playWrongAnswerFeedback()
            HapticFeedbackManager.shared.playErrorPattern()
        }
    }
    
    func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            isAnswerCorrect = nil
        } else {
            isQuizComplete = true
            
            // Play appropriate feedback based on score
            if isPassed {
                VisualFeedbackManager.shared.playVictoryFeedback()
            } else {
                VisualFeedbackManager.shared.playMilestoneFeedback()
            }
        }
    }
    
    private func generateQuestions(from words: [Word]) -> [QuizQuestion] {
        var questions: [QuizQuestion] = []
        
        // Ensure we have at least 3 words
        guard words.count >= 3 else { return [] }
        
        // Create a question for each word
        for word in words {
            // For each word, create a definition-to-term question
            let correctAnswer = word.term
            
            // Get 3 incorrect options from other words
            var options = words.filter { $0.id != word.id }.map { $0.term }
            options.shuffle()
            options = Array(options.prefix(3))
            
            // Add correct answer and shuffle
            options.append(correctAnswer)
            options.shuffle()
            
            let question = QuizQuestion(
                word: word,
                correctAnswer: correctAnswer,
                options: options,
                questionType: .definitionToTerm,
                question: "Which word matches this definition?"
            )
            
            questions.append(question)
        }
        
        return questions
    }
}
