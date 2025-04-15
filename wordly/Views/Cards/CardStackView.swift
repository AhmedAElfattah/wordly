import SwiftUI

struct CardStackView: View {
    @ObservedObject var viewModel: WordCardViewModel
    @State private var showCompletionAnimation = false
    @State private var completedCycle = false
    @State private var showQuiz = false
    @StateObject private var quizViewModel: QuizViewModel
    @State private var dragAmount = CGSize.zero
    @State private var cardRotation: Double = 0
    @State private var cardScale: CGFloat = 1.0
    @State private var swipeDirection: WordCardViewModel.SwipeDirection? = nil
    @State private var isCardActive = false
    @State private var animateBackground = false
    @Namespace private var cardNamespace
    @StateObject private var scrollProxy = ScrollViewProxy()

    init(viewModel: WordCardViewModel) {
        self.viewModel = viewModel
        _quizViewModel = StateObject(wrappedValue: QuizViewModel(words: viewModel.words))
    }

    var body: some View {
        ZStack {
            // Dynamic background
            ZStack {
                Color.background.ignoresSafeArea()

                ForEach(0..<5) { index in
                    Circle()
                        .fill(Color.primary.opacity(0.03))
                        .frame(width: 100 + CGFloat(index * 50))
                        .offset(
                            x: animateBackground ? CGFloat.random(in: -5...5) : 0,
                            y: animateBackground ? CGFloat.random(in: -5...5) : 0
                        )
                        .blur(radius: 3)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animateBackground = true
                }
            }

            // Main content
            VStack {
                // Word card
                ZStack {
                    // Current card
                    WordCardView(word: viewModel.currentWord)
                        .id("\(viewModel.currentIndex)-\(viewModel.currentWord.id)")
                        .environmentObject(scrollProxy)
                        .offset(dragAmount)
                        .rotationEffect(.degrees(cardRotation))
                        .scaleEffect(cardScale)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    // Update translation based on drag
                                    dragAmount = gesture.translation

                                    // Determine swipe direction
                                    let xOffset = gesture.translation.width

                                    // Calculate rotation based on horizontal drag
                                    cardRotation = Double(xOffset) * 0.1

                                    // Determine probable swipe direction
                                    swipeDirection = xOffset > 0 ? .right : .left

                                    // Visual feedback
                                    isCardActive = true
                                }
                                .onEnded { gesture in
                                    // Determine if this is a swipe or reset
                                    let threshold: CGFloat = 100
                                    let xOffset = gesture.translation.width

                                    if abs(xOffset) > threshold {
                                        // Handle swipe
                                        performSwipe(xOffset > 0 ? .right : .left)
                                    } else {
                                        // Reset card position with animation
                                        withAnimation(.spring()) {
                                            dragAmount = .zero
                                            cardRotation = 0
                                            cardScale = 1.0
                                            isCardActive = false
                                            swipeDirection = nil
                                        }
                                    }
                                }
                        )
                        .animation(.spring(), value: dragAmount)
                        .overlay(
                            // Swipe indicators
                            Group {
                                if let direction = swipeDirection, isCardActive {
                                    SwipeIndicatorOverlay(direction: direction)
                                        .opacity(
                                            Double(
                                                min(
                                                    1.0,
                                                    abs(dragAmount.width) / 100)
                                            )
                                        )
                                }
                            }
                        )
                }
                .frame(height: 400)
                .padding(.horizontal)

                // Swipe instruction
                Text("Swipe left or right to navigate")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .padding(.top, 8)

                // Action buttons
                HStack(spacing: 30) {
                    SwipeButton(icon: "arrow.left.circle.fill", color: .blue) {
                        performSwipe(.left)
                    }

                    SwipeButton(icon: "arrow.right.circle.fill", color: .blue) {
                        performSwipe(.right)
                    }
                }
                .padding(.top, 16)

                Spacer()
            }
            .padding(.top)

            // Quiz popup when cycle completes
            if showQuiz {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showQuiz = false
                    }

                VStack {
                    Text("Ready for a quiz?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Test your knowledge on the words you've learned")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    HStack(spacing: 20) {
                        Button("Not Now") {
                            withAnimation {
                                showQuiz = false
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)

                        Button("Start Quiz") {
                            withAnimation {
                                showQuiz = false
                                // Start quiz
                                quizViewModel.startQuiz(with: viewModel.getQuizWords())
                                // Show quiz view
                                // This would be handled by the parent view
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundColor(.primary)
                    }
                    .padding(.top, 20)
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.primary.opacity(0.8))
                )
                .shadow(radius: 20)
            }

            // Cycle completion popup
            if completedCycle && viewModel.shouldShowCyclePrompt() {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        completedCycle = false
                    }

                VStack {
                    Text("Cycle Completed!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("You've completed a cycle of 5 words")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    Button("Continue") {
                        withAnimation {
                            completedCycle = false

                            // Check if we should show quiz
                            if viewModel.shouldShowQuiz() {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    showQuiz = true
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(width: 200)
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.primary)
                    .padding(.top, 20)
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.primary.opacity(0.8))
                )
                .shadow(radius: 20)
            }
        }
    }

    private func performSwipe(_ direction: WordCardViewModel.SwipeDirection) {
        // Apply visual effect for swipe
        withAnimation(.spring()) {
            switch direction {
            case .left:
                dragAmount = CGSize(width: -500, height: 0)
                cardRotation = -10
            case .right:
                dragAmount = CGSize(width: 500, height: 0)
                cardRotation = 10
            }
            cardScale = 0.8
        }

        // Provide haptic feedback
        HapticFeedbackManager.shared.playEnhancedSwipe()
        VisualFeedbackManager.shared.playSwipeFeedback()

        // Process the swipe after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Reset card for next word
            dragAmount = .zero
            cardRotation = 0
            cardScale = 1.0
            isCardActive = false
            swipeDirection = nil

            // Increment word count
            viewModel.incrementWordsViewedToday()

            // Move to next word with wrap-around
            viewModel.currentIndex = (viewModel.currentIndex + 1) % viewModel.words.count

            // Check if we completed a cycle of 5 words
            if viewModel.wordsViewedToday % 5 == 0 {
                viewModel.completedCycle()

                // Only show cycle completion if daily goal is not completed
                if viewModel.shouldShowCyclePrompt() {
                    completedCycle = true
                    HapticFeedbackManager.shared.playCycleCompletion()
                }
            }

            // Reset scroll position for new card
            scrollProxy.scrollToTop()
        }
    }
}

// Helper components

struct SwipeButton: View {
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .padding(12)
                .background(Circle().fill(Color.cardBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct SwipeIndicatorOverlay: View {
    let direction: WordCardViewModel.SwipeDirection

    var body: some View {
        ZStack {
            // Direction indicator
            VStack {
                Spacer()

                HStack {
                    if direction == .left {
                        Image(systemName: "arrow.left")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(20)
                            .background(Circle().fill(Color.blue.opacity(0.8)))

                        Spacer()
                    } else {
                        Spacer()

                        Image(systemName: "arrow.right")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(20)
                            .background(Circle().fill(Color.blue.opacity(0.8)))
                    }
                }
                .padding(.bottom, 40)
                .padding(.horizontal, 40)
            }
        }
    }
}

class ScrollViewProxy: ObservableObject {
    @Published var scrollToTopTrigger = false

    func scrollToTop() {
        scrollToTopTrigger.toggle()
    }
}
