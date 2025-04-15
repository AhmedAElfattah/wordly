import SwiftUI

struct PopQuizFeature: View {
    @ObservedObject var viewModel: QuizViewModel
    @Binding var isPresented: Bool
    @State private var showVictoryAnimation = false

    var body: some View {
        ZStack {
            if viewModel.isQuizComplete {
                // Show results screen
                QuizResultView(
                    score: viewModel.score,
                    totalQuestions: viewModel.questions.count,
                    onDismiss: {
                        if viewModel.isPassed {
                            // Show victory animation before dismissing
                            showVictoryAnimation = true
                            SoundManager.shared.playVictorySound()
                            HapticFeedbackManager.shared.playSuccessPattern()
                        } else {
                            // Just dismiss
                            isPresented = false
                        }
                    }
                )
            } else {
                // Show current question
                QuizQuestionView(
                    question: viewModel.currentQuestion,
                    selectedAnswer: $viewModel.selectedAnswer,
                    isAnswerCorrect: viewModel.isAnswerCorrect,
                    onAnswerSelected: { answer in
                        viewModel.selectAnswer(answer)
                    },
                    onNextQuestion: {
                        viewModel.moveToNextQuestion()
                    }
                )
            }

        }
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

struct QuizQuestionView: View {
    let question: QuizQuestion
    @Binding var selectedAnswer: String?
    let isAnswerCorrect: Bool?
    let onAnswerSelected: (String) -> Void
    let onNextQuestion: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Pop Quiz!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 16) {
                Text("Which word matches this definition?")
                    .font(.headline)
                    .foregroundColor(.textPrimary)

                Text(question.word.definition)
                    .font(.body)
                    .foregroundColor(.textPrimary)
                    .padding(.bottom, 8)

                VStack(spacing: 12) {
                    ForEach(question.options, id: \.self) { option in
                        Button(action: {
                            if selectedAnswer == nil {
                                SoundManager.shared.playButtonSound()
                                HapticFeedbackManager.shared.playSelection()
                                onAnswerSelected(option)
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .font(.body)
                                    .foregroundColor(
                                        selectedAnswer == option
                                            ? (isAnswerCorrect == true ? .white : .white)
                                            : .textPrimary
                                    )

                                Spacer()

                                if selectedAnswer == option {
                                    Image(
                                        systemName: isAnswerCorrect == true
                                            ? "checkmark.circle.fill" : "xmark.circle.fill"
                                    )
                                    .foregroundColor(isAnswerCorrect == true ? .green : .red)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        selectedAnswer == option
                                            ? (isAnswerCorrect == true ? Color.green : Color.red)
                                            : Color.cardBackground
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        selectedAnswer == option
                                            ? (isAnswerCorrect == true ? Color.green : Color.red)
                                            : Color.gray.opacity(0.3),
                                        lineWidth: 1
                                    )
                            )
                        }
                        .disabled(selectedAnswer != nil)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cardBackground)
            )
            .padding(.horizontal, 20)

            if selectedAnswer != nil {
                VStack {
                    Text(isAnswerCorrect == true ? "Correct!" : "Incorrect!")
                        .font(.headline)
                        .foregroundColor(isAnswerCorrect == true ? .green : .red)
                        .padding(.top, 8)

                    if isAnswerCorrect == false {
                        Text("The correct answer is: \(question.correctAnswer)")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .padding(.top, 4)
                    }

                    Button(action: {
                        SoundManager.shared.playButtonSound()
                        HapticFeedbackManager.shared.playSelection()
                        onNextQuestion()
                    }) {
                        Text("Next Question")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200)
                            .background(Color.primary)
                            .cornerRadius(10)
                    }
                    .padding(.top, 16)
                }
            }
        }
        .padding()
    }
}

struct QuizResultView: View {
    let score: Int
    let totalQuestions: Int
    let onDismiss: () -> Void

    var isPassed: Bool {
        // Pass if score is at least 70%
        let passingScore = Int(Double(totalQuestions) * 0.7)
        return score >= passingScore
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Quiz Results")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            VStack(spacing: 8) {
                Text("\(score) / \(totalQuestions)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(isPassed ? .green : .red)

                Text(isPassed ? "Great job!" : "Keep practicing!")
                    .font(.headline)
                    .foregroundColor(isPassed ? .green : .red)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cardBackground)
            )
            .padding(.horizontal, 20)

            if isPassed {
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                    .shadow(color: .yellow.opacity(0.5), radius: 10, x: 0, y: 0)
            } else {
                Image(systemName: "book.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.primary)
            }

            Text(
                isPassed
                    ? "You've mastered these words! Keep up the good work!"
                    : "Don't worry! Learning takes time. Keep practicing these words."
            )
            .font(.body)
            .foregroundColor(.textSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)

            Button(action: {
                SoundManager.shared.playButtonSound()
                HapticFeedbackManager.shared.playSelection()
                onDismiss()
            }) {
                Text(isPassed ? "Celebrate!" : "Continue Learning")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 250)
                    .background(isPassed ? Color.green : Color.primary)
                    .cornerRadius(10)
            }
            .padding(.top, 16)
        }
        .padding()
    }
}
