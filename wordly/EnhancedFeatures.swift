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
    @EnvironmentObject private var scrollProxy: ScrollViewProxy

    var body: some View {
        ScrollView(showsIndicators: true) {
            ScrollViewReader { scrollReader in
                VStack(alignment: .leading, spacing: 16) {
                    // Word and pronunciation
                    VStack(alignment: .leading, spacing: 4) {
                        Text(word.term)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .id("top")  // Add an ID for the top of the content

                        Text(word.pronunciation)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(word.partOfSpeech)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                    }
                    .opacity(1.0)
                    .padding(.top, 24)

                    // Mastery indicator with animation
                    EnhancedMasteryIndicatorView(level: word.masteryLevel)
                        .opacity(isShowingMastery ? 1 : 0)
                        .offset(y: isShowingMastery ? 0 : 20)
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.7).delay(0.1),
                            value: isShowingMastery
                        )

                    Divider()

                    // Definition with animation
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Definition")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textSecondary)

                        Text(word.definition)
                            .font(.body)
                            .foregroundColor(.textPrimary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .opacity(isShowingDefinition ? 1 : 0)
                    .offset(y: isShowingDefinition ? 0 : 20)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.7).delay(0.2),
                        value: isShowingDefinition
                    )

                    // Example with animation
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Example")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textSecondary)

                        Text(word.example)
                            .font(.body)
                            .italic()
                            .foregroundColor(.textSecondary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .opacity(isShowingExample ? 1 : 0)
                    .offset(y: isShowingExample ? 0 : 20)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.7).delay(0.3),
                        value: isShowingExample
                    )

                    // Add extra space at the bottom to push content up
                    Spacer(minLength: 100)
                }
                .padding(20)
                .onChange(of: scrollProxy.scrollToTopTrigger) { _ in
                    withAnimation {
                        scrollReader.scrollTo("top", anchor: .top)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
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
                    EnhancedWordCardView(word: viewModel.currentWord)
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
                                    let yOffset = gesture.translation.height

                                    // Calculate rotation based on horizontal drag
                                    cardRotation = Double(xOffset) * 0.1

                                    // Determine probable swipe direction
                                    if abs(xOffset) > abs(yOffset) {
                                        // Horizontal swipe
                                        swipeDirection = xOffset > 0 ? .right : .left
                                    } else {
                                        // Vertical swipe
                                        swipeDirection = yOffset > 0 ? .down : .up
                                    }

                                    // Visual feedback
                                    isCardActive = true
                                }
                                .onEnded { gesture in
                                    // Determine if this is a swipe or reset
                                    let threshold: CGFloat = 100
                                    let xOffset = gesture.translation.width
                                    let yOffset = gesture.translation.height

                                    if abs(xOffset) > threshold || abs(yOffset) > threshold {
                                        // Handle swipe
                                        if abs(xOffset) > abs(yOffset) {
                                            // Horizontal swipe - advance to next card
                                            performSwipe(xOffset > 0 ? .right : .left)
                                        } else {
                                            // Vertical swipe - mark as known or not
                                            performSwipe(yOffset > 0 ? .down : .up)
                                        }
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
                                            min(
                                                1.0,
                                                abs(dragAmount.width) / 100 + abs(dragAmount.height)
                                                    / 100))
                                }
                            }
                        )
                }
                .frame(height: 400)
                .padding(.horizontal)

                // Swipe instruction
                Text("Swipe up if you know it, down if you don't")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                    .padding(.top, 8)

                // Action buttons
                HStack(spacing: 30) {
                    SwipeButton(icon: "xmark.circle.fill", color: .red) {
                        performSwipe(.down)
                    }

                    SwipeButton(icon: "arrow.left.circle.fill", color: .blue) {
                        performSwipe(.left)
                    }

                    SwipeButton(icon: "arrow.right.circle.fill", color: .blue) {
                        performSwipe(.right)
                    }

                    SwipeButton(icon: "checkmark.circle.fill", color: .green) {
                        performSwipe(.up)
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
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Start Quiz") {
                            showQuiz = false
                            // Navigate to quiz (handled in parent view)
                        }
                        .padding()
                        .background(Color.primary)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primary, Color.secondary]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                )
                .padding(40)
                .transition(.scale.combined(with: .opacity))
            }

            // Cycle completion animation
            if showCompletionAnimation {
                VStack {
                    Text("Cycle Completed!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Great job going through all the words!")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button("Continue") {
                        withAnimation {
                            showCompletionAnimation = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    if viewModel.shouldShowQuiz() {
                                        showQuiz = true
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    .padding(.top, 16)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primary, Color.accent]),
                                startPoint: .top,
                                endPoint: .bottom
                            ))
                )
                .shadow(radius: 20)
                .transition(.scale.combined(with: .opacity))
                .zIndex(2)
            }
        }
    }

    private func performSwipe(_ direction: WordCardViewModel.SwipeDirection) {
        // Determine target position for animation
        var targetPosition = CGSize.zero

        switch direction {
        case .up:
            targetPosition = CGSize(width: 0, height: -1000)
            // Mark word as known
            viewModel.markCurrentWordAsKnown()
            HapticFeedbackManager.shared.playProgressiveHaptic(
                for: viewModel.currentWord.masteryLevel)
        case .down:
            targetPosition = CGSize(width: 0, height: 1000)
            HapticFeedbackManager.shared.playEnhancedSwipe()
        case .left:
            targetPosition = CGSize(width: -1000, height: 0)
            HapticFeedbackManager.shared.playEnhancedSwipe()
        case .right:
            targetPosition = CGSize(width: 1000, height: 0)
            HapticFeedbackManager.shared.playEnhancedSwipe()
        }

        // Animate the card off screen
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            dragAmount = targetPosition

            // Add rotation for more natural movement
            switch direction {
            case .up, .down:
                cardRotation = Double.random(in: -5...5)
            case .left:
                cardRotation = -10
            case .right:
                cardRotation = 10
            }
        }

        // Play swipe sound
        SoundManager.shared.playSwipeSound()

        // Increment the counter
        viewModel.incrementWordsViewedToday()

        // Post notification for UI updates
        NotificationCenter.default.post(name: .wordCardSwiped, object: nil)

        // Force the model to notify changes
        DispatchQueue.main.async {
            self.viewModel.objectWillChange.send()
        }

        // After animation, move to next card
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Check if we've completed a full cycle
            if viewModel.currentIndex == viewModel.words.count - 1 {
                // Show completion animation
                viewModel.completedCycle()

                withAnimation {
                    showCompletionAnimation = true
                }

                // Play completion sound and haptics
                SoundManager.shared.playVictorySound()
                HapticFeedbackManager.shared.playCycleCompletion()
            }

            // Update current index (cycle through the cards)
            let newIndex = (viewModel.currentIndex + 1) % viewModel.words.count
            viewModel.currentIndex = newIndex

            // Reset the scroll position to top for the new card
            scrollProxy.scrollToTop()

            // Reset card state with no animation
            dragAmount = .zero
            cardRotation = 0
            isCardActive = false
            swipeDirection = nil

            // Apply a subtle "appear" animation for the next card
            cardScale = 0.8
            withAnimation(.spring()) {
                cardScale = 1.0
            }
        }
    }
}

// Add this class to handle scroll position reset
class ScrollViewProxy: ObservableObject {
    @Published var scrollToTopTrigger = false

    func scrollToTop() {
        scrollToTopTrigger.toggle()
    }
}

// MARK: - Supporting Views

struct SwipeButton: View {
    let icon: String
    let color: Color
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            isPressed = true

            // Haptic feedback
            HapticFeedbackManager.shared.playSelection()

            // Perform action
            action()

            // Reset pressed state
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .padding(12)
                .background(
                    Circle()
                        .fill(Color.cardBackground)
                        .shadow(color: color.opacity(0.2), radius: 5, x: 0, y: 2)
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
    }
}

struct SwipeIndicatorOverlay: View {
    let direction: WordCardViewModel.SwipeDirection

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(indicatorColor.opacity(0.7), lineWidth: 3)
                    .background(indicatorColor.opacity(0.2))
                    .cornerRadius(20)

                VStack {
                    indicatorIcon
                        .font(.system(size: 50))
                        .foregroundColor(indicatorColor)

                    Text(indicatorText)
                        .font(.headline)
                        .foregroundColor(indicatorColor)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private var indicatorColor: Color {
        switch direction {
        case .up:
            return .green
        case .down:
            return .red
        case .left, .right:
            return .blue
        }
    }

    private var indicatorIcon: some View {
        switch direction {
        case .up:
            return Image(systemName: "checkmark.circle.fill")
        case .down:
            return Image(systemName: "xmark.circle.fill")
        case .left:
            return Image(systemName: "arrow.left.circle.fill")
        case .right:
            return Image(systemName: "arrow.right.circle.fill")
        }
    }

    private var indicatorText: String {
        switch direction {
        case .up:
            return "I know this!"
        case .down:
            return "Don't know yet"
        case .left:
            return "Previous"
        case .right:
            return "Next"
        }
    }
}

// MARK: - Streak Tracker
class StreakTracker: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0

    init() {
        currentStreak = UserDefaultsManager.shared.getStreakDays()
        bestStreak = UserDefaultsManager.shared.getBestStreak()
    }

    func incrementStreak() {
        currentStreak += 1

        if currentStreak > bestStreak {
            bestStreak = currentStreak
            UserDefaultsManager.shared.saveBestStreak(bestStreak)
        }

        UserDefaultsManager.shared.saveStreakDays(currentStreak)
    }

    func resetStreak() {
        currentStreak = 0
        UserDefaultsManager.shared.saveStreakDays(0)
    }
}

struct StreakView: View {
    @ObservedObject var streakTracker: StreakTracker
    @State private var showAnimation = false

    var body: some View {
        HStack(spacing: 20) {
            // Current streak
            VStack(alignment: .center, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .opacity(showAnimation ? 1 : 0.7)
                        .scaleEffect(showAnimation ? 1.1 : 1.0)

                    Text("\(streakTracker.currentStreak)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                }

                Text("Current")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .frame(width: 80)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
            )

            // Best streak
            VStack(alignment: .center, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.yellow)

                    Text("\(streakTracker.bestStreak)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                }

                Text("Best")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .frame(width: 80)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.cardBackground)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
            )
        }
        .padding(.horizontal)
        .onAppear {
            // Animate flame when view appears
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                showAnimation = true
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
        VStack(spacing: 10) {
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
            .frame(maxHeight: UIScreen.main.bounds.height * 0.7)

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
                } else {
                    // Empty view to maintain layout balance
                    Spacer().frame(width: 100)
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
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Tutorial Page
struct TutorialPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

// MARK: - Tutorial Page View
struct TutorialPageView: View {
    let page: TutorialPage

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Image(systemName: page.imageName)
                    .font(.system(size: 70))
                    .foregroundColor(.primary)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 150, height: 150)
                    )
                    .scaleEffect(1.0)
                    .animation(
                        .easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: UUID())

                Text(page.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Text(page.description)
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 40)
            }
            .padding(.top, 40)
            .padding(.bottom, 20)
        }
    }
}
