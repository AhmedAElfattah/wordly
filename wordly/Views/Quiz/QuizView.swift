import SwiftUI

struct QuizView: View {
    @ObservedObject var viewModel: QuizViewModel
    @Binding var isShowing: Bool

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        isShowing = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.textPrimary)
                            .padding(10)
                            .background(Circle().fill(Color.cardBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }

                    Spacer()

                    Text("Vocabulary Quiz")
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    // Placeholder to balance layout
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal)

                if viewModel.isQuizComplete {
                    QuizResultView(viewModel: viewModel, isShowing: $isShowing)
                } else if viewModel.currentQuestionIndex < viewModel.questions.count {
                    QuizQuestionView(viewModel: viewModel)
                }
            }
            .padding(.top)
        }
    }
}

struct QuizResultView: View {
    @ObservedObject var viewModel: QuizViewModel
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Quiz Completed!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(Color.primary)

                Circle()
                    .trim(
                        from: 0.0,
                        to: CGFloat(viewModel.score)
                            / CGFloat(viewModel.questions.count)
                    )
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 20, lineCap: .round, lineJoin: .round)
                    )
                    .foregroundColor(
                        viewModel.isPassed ? .green : .orange
                    )
                    .rotationEffect(Angle(degrees: 270.0))

                VStack {
                    Text("\(viewModel.score)/\(viewModel.questions.count)")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)

                    Text(
                        "\(Int(Double(viewModel.score) / Double(viewModel.questions.count) * 100))%"
                    )
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                }
            }
            .frame(width: 200, height: 200)
            .padding()

            Text(viewModel.isPassed ? "Great job!" : "Keep practicing!")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            Button(action: {
                viewModel.currentQuestionIndex = 0
                viewModel.selectedAnswer = nil
                viewModel.isAnswerCorrect = nil
                viewModel.score = 0
                viewModel.isQuizComplete = false
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.primary)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }

            Button(action: {
                isShowing = false
            }) {
                Text("Back to Words")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
        .padding()
    }
}

struct QuizQuestionView: View {
    @ObservedObject var viewModel: QuizViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Question card
            VStack(alignment: .leading, spacing: 16) {
                Text("Which word matches this definition?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom)

                Text(viewModel.currentQuestion.word.definition)
                    .font(.body)
                    .foregroundColor(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
            .padding(.horizontal)

            // Answer options
            VStack(spacing: 12) {
                ForEach(viewModel.currentQuestion.options, id: \.self) { option in
                    Button(action: {
                        if viewModel.selectedAnswer == nil {
                            viewModel.selectAnswer(option)
                        }
                    }) {
                        HStack {
                            Text(option)
                                .font(.body)
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)

                            Spacer()

                            if viewModel.selectedAnswer == option {
                                Image(
                                    systemName: viewModel.isAnswerCorrect == true
                                        ? "checkmark.circle.fill" : "xmark.circle.fill"
                                )
                                .foregroundColor(
                                    viewModel.isAnswerCorrect == true ? .green : .red)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    viewModel.selectedAnswer == option
                                        ? (viewModel.isAnswerCorrect == true
                                            ? Color.green.opacity(0.2)
                                            : Color.red.opacity(0.2))
                                        : Color.cardBackground
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    viewModel.selectedAnswer == option
                                        ? (viewModel.isAnswerCorrect == true
                                            ? Color.green
                                            : Color.red)
                                        : Color.clear,
                                    lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                    .disabled(viewModel.selectedAnswer != nil)
                }
            }
            .padding(.horizontal)

            // Next button
            if viewModel.selectedAnswer != nil {
                Button(action: {
                    viewModel.moveToNextQuestion()
                }) {
                    Text("Next Question")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.primary)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
