import SwiftUI

struct WordCardView: View {
    let word: Word
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Word and pronunciation
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(word.term)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text(word.pronunciation)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                // Mastery level indicator
                MasteryLevelBadge(level: word.masteryLevel)
            }
            
            // Part of speech
            Text(word.partOfSpeech)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.primary.opacity(0.8))
                .cornerRadius(4)
            
            // Definition
            VStack(alignment: .leading, spacing: 8) {
                Text("Definition")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text(word.definition)
                    .font(.body)
                    .foregroundColor(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Example
            VStack(alignment: .leading, spacing: 8) {
                Text("Example")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text(word.example)
                    .font(.body)
                    .foregroundColor(.textPrimary)
                    .italic()
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // Swipe instructions
            HStack {
                VStack(alignment: .center, spacing: 4) {
                    Image(systemName: "arrow.up")
                        .foregroundColor(.green)
                    Text("I know this")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 4) {
                    Image(systemName: "arrow.down")
                        .foregroundColor(.red)
                    Text("Still learning")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.top)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

struct MasteryLevelBadge: View {
    let level: MasteryLevel
    
    var body: some View {
        Text(level.description)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(hex: level.color))
            .cornerRadius(12)
    }
}

struct EnhancedVerticalCardStackView: View {
    @ObservedObject var viewModel: WordCardViewModel
    @State private var offset: CGFloat = 0
    @State private var isDragging = false
    @State private var showQuiz = false
    
    var body: some View {
        ZStack {
            // Main word card
            WordCardView(word: viewModel.currentWord)
                .offset(y: offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            isDragging = true
                            offset = gesture.translation.height
                            viewModel.updateSwipeStatus(with: CGSize(width: 0, height: offset))
                        }
                        .onEnded { gesture in
                            isDragging = false
                            
                            if offset < -100 {
                                // Swiped up (known)
                                withAnimation(.spring()) {
                                    offset = -UIScreen.main.bounds.height
                                }
                                
                                // Play haptic feedback and sound
                                HapticFeedbackManager.shared.playMediumTap()
                                SoundManager.shared.playSwipeSound()
                                
                                // Mark word as known
                                viewModel.markCurrentWordAsKnown()
                                
                                // Move to next word
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    let oldIndex = viewModel.currentIndex
                                    viewModel.currentIndex = CardLoopingManager.getNextIndex(
                                        currentIndex: viewModel.currentIndex,
                                        totalCount: viewModel.words.count
                                    )
                                    
                                    // Check if we completed a cycle
                                    if viewModel.currentIndex < oldIndex {
                                        viewModel.completedCycle()
                                        
                                        // Check if we should show quiz
                                        if viewModel.shouldShowQuiz() {
                                            showQuiz = true
                                        }
                                    }
                                    
                                    // Increment words viewed
                                    viewModel.incrementWordsViewedToday()
                                    
                                    // Reset offset and swipe status
                                    offset = 0
                                    viewModel.resetSwipe()
                                }
                            } else if offset > 100 {
                                // Swiped down (still learning)
                                withAnimation(.spring()) {
                                    offset = UIScreen.main.bounds.height
                                }
                                
                                // Play haptic feedback and sound
                                HapticFeedbackManager.shared.playLightTap()
                                SoundManager.shared.playSwipeSound()
                                
                                // Move to next word
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    let oldIndex = viewModel.currentIndex
                                    viewModel.currentIndex = CardLoopingManager.getNextIndex(
                                        currentIndex: viewModel.currentIndex,
                                        totalCount: viewModel.words.count
                                    )
                                    
                                    // Check if we completed a cycle
                                    if viewModel.currentIndex < oldIndex {
                                        viewModel.completedCycle()
                                        
                                        // Check if we should show quiz
                                        if viewModel.shouldShowQuiz() {
                                            showQuiz = true
                                        }
                                    }
                                    
                                    // Increment words viewed
                                    viewModel.incrementWordsViewedToday()
                                    
                                    // Reset offset and swipe status
                                    offset = 0
                                    viewModel.resetSwipe()
                                }
                            } else {
                                // Return to center
                                withAnimation(.spring()) {
                                    offset = 0
                                }
                                viewModel.resetSwipe()
                            }
                        }
                )
                .animation(.spring(), value: offset)
            
            // Swipe indicators
            VStack {
                if offset < -50 {
                    SwipeIndicator(
                        direction: .up,
                        text: "I know this",
                        color: .green,
                        opacity: Double(min(1.0, abs(offset) / 100))
                    )
                    .transition(.opacity)
                }
                
                Spacer()
                
                if offset > 50 {
                    SwipeIndicator(
                        direction: .down,
                        text: "Still learning",
                        color: .red,
                        opacity: Double(min(1.0, abs(offset) / 100))
                    )
                    .transition(.opacity)
                }
            }
            .padding(.vertical, 40)
        }
        .sheet(isPresented: $showQuiz) {
            QuizView(
                viewModel: QuizViewModel(words: viewModel.getQuizWords()),
                onComplete: {
                    showQuiz = false
                    viewModel.resetToFirstWord()
                }
            )
        }
    }
}

struct SwipeIndicator: View {
    enum Direction {
        case up, down
    }
    
    let direction: Direction
    let text: String
    let color: Color
    let opacity: Double
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: direction == .up ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .font(.title)
                .foregroundColor(color)
            
            Text(text)
                .font(.headline)
                .foregroundColor(color)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .opacity(opacity)
    }
}

struct QuizView: View {
    @ObservedObject var viewModel: QuizViewModel
    let onComplete: () -> Void
    @State private var showVictoryAnimation = false
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            if viewModel.isQuizComplete {
                QuizResultView(
                    score: viewModel.score,
                    totalQuestions: viewModel.questions.count,
                    isPassed: viewModel.isPassed,
                    onContinue: {
                        if viewModel.isPassed {
                            showVictoryAnimation = true
                        } else {
                            onComplete()
                        }
                    }
                )
            } else {
                VStack(spacing: 24) {
                    // Progress indicator
                    HStack {
                        Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.questions.count)")
                            .font(.headline)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                        
                        Text("Score: \(viewModel.score)")
                            .font(.headline)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal)
                    
                    // Question
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Which word matches this definition?")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                        
                        Text(viewModel.currentQuestion.word.definition)
                            .font(.body)
                            .foregroundColor(.textPrimary)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.cardBackground)
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Answer options
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.currentQuestion.options, id: \.self) { option in
                                AnswerOptionButton(
                                    text: option,
                                    isSelected: viewModel.selectedAnswer == option,
                                    isCorrect: viewModel.isAnswerCorrect == true && option == viewModel.currentQuestion.correctAnswer,
                                    isIncorrect: viewModel.isAnswerCorrect == false && option == viewModel.selectedAnswer,
                                    isDisabled: viewModel.selectedAnswer != nil,
                                    action: {
                                        viewModel.selectAnswer(option)
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    // Next button
                    if viewModel.selectedAnswer != nil {
                        Button(action: {
                            SoundManager.shared.playButtonSound()
                            HapticFeedbackManager.shared.playSelection()
                            viewModel.moveToNextQuestion()
                        }) {
                            Text("Next Question")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.primary)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            
            // Victory animation overlay
            if showVictoryAnimation {
                VictoryAnimationView(onComplete: onComplete)
            }
        }
    }
}

struct AnswerOptionButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isIncorrect: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.headline)
                    .foregroundColor(textColor)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                } else if isIncorrect {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                } else if isSelected {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.primary)
                        .font(.title3)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
    }
    
    private var backgroundColor: Color {
        if isCorrect {
            return Color.green.opacity(0.2)
        } else if isIncorrect {
            return Color.red.opacity(0.2)
        } else if isSelected {
            return Color.primary.opacity(0.1)
        } else {
            return Color.cardBackground
        }
    }
    
    private var borderColor: Color {
        if isCorrect {
            return Color.green
        } else if isIncorrect {
            return Color.red
        } else if isSelected {
            return Color.primary
        } else {
            return Color.gray.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        if isCorrect {
            return Color.green
        } else if isIncorrect {
            return Color.red
        } else {
            return .textPrimary
        }
    }
}

struct QuizResultView: View {
    let score: Int
    let totalQuestions: Int
    let isPassed: Bool
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            // Result icon
            Image(systemName: isPassed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(isPassed ? .green : .red)
                .padding()
            
            // Result text
            Text(isPassed ? "Great Job!" : "Keep Practicing!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            Text("You scored \(score) out of \(totalQuestions)")
                .font(.title3)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Score percentage
            let percentage = Double(score) / Double(totalQuestions) * 100
            Text("\(Int(percentage))%")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(isPassed ? .green : .red)
                .padding()
            
            Spacer()
            
            // Continue button
            Button(action: onContinue) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primary)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct VictoryAnimationView: View {
    let onComplete: () -> Void
    @State private var showAnimation = false
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Trophy icon
                Image(systemName: "trophy.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.yellow)
                    .shadow(color: .yellow.opacity(0.5), radius: 10, x: 0, y: 0)
                    .scaleEffect(showAnimation ? 1.0 : 0.1)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showAnimation)
                
                // Victory text
                Text("Victory!")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .opacity(showAnimation ? 1.0 : 0.0)
                    .animation(.easeIn.delay(0.3), value: showAnimation)
                
                Text("You've mastered these words!")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(showAnimation ? 1.0 : 0.0)
                    .animation(.easeIn.delay(0.5), value: showAnimation)
                
                // Continue button
                Button(action: {
                    SoundManager.shared.playButtonSound()
                    HapticFeedbackManager.shared.playSelection()
                    onComplete()
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .opacity(showAnimation ? 1.0 : 0.0)
                .animation(.easeIn.delay(0.7), value: showAnimation)
            }
            .padding()
            
            // Confetti
            ConfettiView()
                .opacity(showAnimation ? 1.0 : 0.0)
        }
        .onAppear {
            // Play sound and haptic feedback
            SoundManager.shared.playVictorySound()
            HapticFeedbackManager.shared.playSuccessPattern()
            
            // Start animations
            withAnimation {
                showAnimation = true
            }
        }
    }
}
