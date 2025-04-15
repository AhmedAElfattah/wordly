import SwiftUI

// MARK: - Enhanced Haptic Feedback
extension HapticFeedbackManager {
    // Enhanced haptic feedback for word mastery progression
    func playProgressiveHaptic(for masteryLevel: MasteryLevel) {
        switch masteryLevel {
        case .new:
            // Subtle single tap
            playImpact(style: .light)
        case .learning:
            // Double tap with increasing intensity
            DispatchQueue.main.async {
                self.playImpact(style: .light)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playImpact(style: .medium)
                }
            }
        case .familiar:
            // Triple tap pattern
            DispatchQueue.main.async {
                self.playImpact(style: .light)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playImpact(style: .medium)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.playImpact(style: .medium)
                    }
                }
            }
        case .mastered:
            // Success pattern with crescendo
            DispatchQueue.main.async {
                self.playImpact(style: .light)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.playImpact(style: .medium)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.playImpact(style: .heavy)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.playNotification(type: .success)
                        }
                    }
                }
            }
        }
    }

    // Enhanced swipe feedback inspired by Squad Busters
    func playEnhancedSwipe() {

        // Negative swipe - decrescendo pattern
        DispatchQueue.main.async {
            self.playImpact(style: .medium)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.playImpact(style: .light)
            }
        }

    }

    // Celebration haptic for completing a full cycle
    func playCycleCompletion() {
        DispatchQueue.main.async {
            self.playImpact(style: .medium)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.playImpact(style: .heavy)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    self.playNotification(type: .success)
                }
            }
        }
    }
}

// MARK: - Enhanced Word Card View with Animations
struct EnhancedWordCardView: View {
    let word: Word
    @State private var isShowingDefinition = false
    @State private var isShowingExample = false
    @State private var isShowingMastery = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Word and pronunciation
            VStack(alignment: .leading, spacing: 4) {
                Text(word.term)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)

                Text(word.pronunciation)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)

                Text(word.partOfSpeech)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
            }
            .opacity(1.0)

            // Mastery indicator with animation
            EnhancedMasteryIndicatorView(level: word.masteryLevel)
                .opacity(isShowingMastery ? 1 : 0)
                .offset(y: isShowingMastery ? 0 : 20)
                .animation(
                    .spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: isShowingMastery
                )

            Divider()

            // Definition with animation
            Text(word.definition)
                .font(.body)
                .foregroundColor(.textPrimary)
                .padding(.vertical, 8)
                .opacity(isShowingDefinition ? 1 : 0)
                .offset(y: isShowingDefinition ? 0 : 20)
                .animation(
                    .spring(response: 0.5, dampingFraction: 0.7).delay(0.2),
                    value: isShowingDefinition)

            // Example with animation
            Text(word.example)
                .font(.body)
                .italic()
                .foregroundColor(.textSecondary)
                .padding(.bottom, 8)
                .opacity(isShowingExample ? 1 : 0)
                .offset(y: isShowingExample ? 0 : 20)
                .animation(
                    .spring(response: 0.5, dampingFraction: 0.7).delay(0.3), value: isShowingExample
                )

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
        .onAppear {
            // Staggered animations for content
            withAnimation(.easeOut(duration: 0.3)) {
                isShowingMastery = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.3)) {
                    isShowingDefinition = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeOut(duration: 0.3)) {
                    isShowingExample = true
                }
            }
        }
    }
}

// MARK: - Enhanced Card Stack with Visual Feedback
struct EnhancedCardStackView: View {
    @ObservedObject var viewModel: WordCardViewModel
    @State private var showCompletionAnimation = false
    @State private var completedCycle = false
    @State private var showQuiz = false
    @StateObject private var quizViewModel: QuizViewModel
    @StateObject private var streakTracker = StreakTracker()

    init(viewModel: WordCardViewModel) {
        self.viewModel = viewModel
        _quizViewModel = StateObject(wrappedValue: QuizViewModel(words: viewModel.words))
    }

    var body: some View {
        ZStack {
            // Background
            AnimatedBackgroundView()

            // Main content
            VStack {
                // Progress indicator
                EnhancedDailyGoalProgressView(
                    goalTracker: DailyGoalTracker(dailyGoal: viewModel.dailyGoal)
                )
                .padding(.horizontal)
                .padding(.top)

                // Streak indicator
                StreakView(streakTracker: streakTracker)
                    .padding(.horizontal)

                // Card stack with vertical scrolling
                TabView(selection: $viewModel.currentIndex) {
                    ForEach(0..<viewModel.words.count, id: \.self) { index in
                        EnhancedWordCardView(word: viewModel.words[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Navigation controls
                HStack {
                    Button(action: {
                        withAnimation {
                            if viewModel.currentIndex > 0 {
                                viewModel.currentIndex -= 1
                            }
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    .disabled(viewModel.currentIndex == 0)

                    Spacer()

                    // Quiz button
                    Button(action: {
                        withAnimation {
                            showQuiz = true
                        }
                    }) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }

                    Spacer()

                    Button(action: {
                        withAnimation {
                            if viewModel.currentIndex < viewModel.words.count - 1 {
                                viewModel.currentIndex += 1
                            } else {
                                viewModel.currentIndex = 0
                                completedCycle = true
                            }
                            viewModel.incrementWordsViewedToday()
                            streakTracker.recordInteraction()
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding()
            }

   

            // Quiz overlay
            if showQuiz {
                QuizView(viewModel: quizViewModel, isShowing: $showQuiz)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

// MARK: - Enhanced Home View
struct EnhancedHomeView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel: WordCardViewModel
    @State private var showingTutorial = false

    init() {
        // Initialize with empty array, will be updated in onAppear
        _viewModel = StateObject(wrappedValue: WordCardViewModel(words: []))
    }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack {
                // Header
                HStack {
                    Text("Vocabulary")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    // Help button
                    Button(action: {
                        HapticFeedbackManager.shared.playSelection()
                        showingTutorial = true
                    }) {
                        Image(systemName: "questionmark.circle")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                .padding()

                // Card Stack
                ZStack {
                    // Only show if we have words
                    if !viewModel.words.isEmpty {
                        EnhancedCardStackView(viewModel: viewModel)
                    } else {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Progress Indicator
                HStack(spacing: 8) {
                    ForEach(0..<min(viewModel.words.count, 5), id: \.self) { index in
                        Circle()
                            .fill(
                                index == viewModel.currentIndex
                                    ? Color.primary : Color.gray.opacity(0.3)
                            )
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == viewModel.currentIndex ? 1.2 : 1.0)
                            .animation(
                                .spring(response: 0.3, dampingFraction: 0.6),
                                value: viewModel.currentIndex)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            // Update the view model with words from app state
            viewModel.words = appState.words
        }
        .sheet(isPresented: $showingTutorial) {
            TutorialView(isPresented: $showingTutorial)
        }
    }
}

// MARK: - Tutorial View
struct TutorialView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0

    let tutorialPages = [
        TutorialPage(
            title: "Welcome to Vocabulary",
            description: "Expand your vocabulary with just a few minutes each day.",
            imageName: "book.fill"
        ),
        TutorialPage(
            title: "Swipe to Learn",
            description:
                "Swipe left or right to navigate through words. Each swipe helps you build your vocabulary.",
            imageName: "hand.draw.fill"
        ),
        TutorialPage(
            title: "Track Your Progress",
            description:
                "Words you interact with more frequently will show increased mastery levels.",
            imageName: "chart.bar.fill"
        ),
        TutorialPage(
            title: "Feel the Difference",
            description:
                "Experience unique haptic feedback patterns as you interact with words and improve your mastery.",
            imageName: "waveform.path.ecg.rectangle.fill"
        ),
    ]

    var body: some View {
        VStack {
            // Close button
            HStack {
                Spacer()
                Button(action: {
                    HapticFeedbackManager.shared.playSelection()
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                }
            }

            // Tutorial content
            TabView(selection: $currentPage) {
                ForEach(0..<tutorialPages.count, id: \.self) { index in
                    TutorialPageView(page: tutorialPages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

            // Navigation buttons
            HStack {
                if currentPage > 0 {
                    Button(action: {
                        HapticFeedbackManager.shared.playSelection()
                        withAnimation {
                            currentPage -= 1
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Previous")
                        }
                        .padding()
                        .foregroundColor(.primary)
                    }
                }

                Spacer()

                if currentPage < tutorialPages.count - 1 {
                    Button(action: {
                        HapticFeedbackManager.shared.playSelection()
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        HStack {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .foregroundColor(.primary)
                    }
                } else {
                    Button(action: {
                        HapticFeedbackManager.shared.playSelection()
                        isPresented = false
                    }) {
                        Text("Get Started")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.primary)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
}

struct TutorialPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct TutorialPageView: View {
    let page: TutorialPage

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: page.imageName)
                .font(.system(size: 80))
                .foregroundColor(.primary)
                .padding()
                .background(
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 150, height: 150)
                )
                .addPulseAnimation()

            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)

            Text(page.description)
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
        .padding(.top, 60)
    }
}

// MARK: - Quiz View
struct QuizView: View {
    @ObservedObject var viewModel: QuizViewModel
    @Binding var isShowing: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                    }
                }

            VStack(spacing: 20) {
                // Question
                Text(viewModel.currentQuestion.word.definition)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                // Options
                VStack(spacing: 15) {
                    ForEach(viewModel.currentQuestion.options, id: \.self) { option in
                        Button(action: {
                            viewModel.selectAnswer(option)
                        }) {
                            Text(option)
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            viewModel.selectedAnswer == option
                                                ? (viewModel.isAnswerCorrect == true
                                                    ? Color.green : Color.red)
                                                : Color.primary.opacity(0.8))
                                )
                        }
                        .disabled(viewModel.selectedAnswer != nil)
                    }
                }
                .padding()

                // Next button
                if viewModel.selectedAnswer != nil {
                    Button(action: {
                        withAnimation {
                            if viewModel.currentQuestionIndex < viewModel.questions.count - 1 {
                                viewModel.moveToNextQuestion()
                            } else {
                                isShowing = false
                            }
                        }
                    }) {
                        Text(
                            viewModel.currentQuestionIndex < viewModel.questions.count - 1
                                ? "Next" : "Finish"
                        )
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cardBackground)
                    .shadow(radius: 10)
            )
            .padding()
        }
    }
}
