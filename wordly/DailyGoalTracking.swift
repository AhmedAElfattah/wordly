import Combine
import SwiftUI

// MARK: - Daily Goal Progress Tracking

class DailyGoalTracker: ObservableObject {
    @Published var wordsViewedToday: Int = 0 {
        didSet {
            // Save progress whenever wordsViewedToday changes directly
            UserDefaultsManager.shared.saveWordsViewedToday(wordsViewedToday)

            // Update goal reached status
            if wordsViewedToday >= dailyGoal && !hasReachedGoalToday {
                hasReachedGoalToday = true
                lastCompletionDate = Date()
                updateStreak()
                UserDefaultsManager.shared.saveLastCompletionDate(lastCompletionDate!)
            }
        }
    }
    @Published var dailyGoal: Int = 10
    @Published var hasReachedGoalToday: Bool = false
    @Published var streakDays: Int = 0
    @Published var bestStreak: Int = 0
    @Published var lastCompletionDate: Date?

    private var cancellables = Set<AnyCancellable>()

    init(dailyGoal: Int = 10) {
        self.dailyGoal = dailyGoal
        loadSavedProgress()

        // Set up notification to observe user defaults changes
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                self?.refreshWordsViewed()
            }
            .store(in: &cancellables)

        // Listen for direct swipe notifications
        NotificationCenter.default.publisher(for: .wordCardSwiped)
            .sink { [weak self] _ in
                self?.refreshWordsViewed()
            }
            .store(in: &cancellables)
    }

    // Refresh the word count from UserDefaults
    private func refreshWordsViewed() {
        let count = UserDefaultsManager.shared.getWordsViewedToday()
        if count != wordsViewedToday {
            DispatchQueue.main.async {
                self.wordsViewedToday = count
            }
        }
    }

    // Load saved progress from UserDefaults
    private func loadSavedProgress() {
        wordsViewedToday = UserDefaultsManager.shared.getWordsViewedToday()
        streakDays = UserDefaultsManager.shared.getStreakDays()
        bestStreak = UserDefaultsManager.shared.getBestStreak()
        lastCompletionDate = UserDefaultsManager.shared.getLastCompletionDate()

        // Check if daily goal was reached today
        hasReachedGoalToday = wordsViewedToday >= dailyGoal

        // If it's a new day, check if streak needs to be updated
        if let lastDate = lastCompletionDate {
            let calendar = Calendar.current
            let lastDay = calendar.startOfDay(for: lastDate)
            let today = calendar.startOfDay(for: Date())

            if !calendar.isDate(lastDay, inSameDayAs: today) {
                // It's a new day, reset daily goal tracking
                resetDailyProgress()
            }
        }
    }

    // Save progress to UserDefaults
    private func saveProgress() {
        UserDefaultsManager.shared.saveWordsViewedToday(wordsViewedToday)
        UserDefaultsManager.shared.saveStreakDays(streakDays)
        UserDefaultsManager.shared.saveBestStreak(bestStreak)

        if let date = lastCompletionDate {
            UserDefaultsManager.shared.saveLastCompletionDate(date)
        }
    }

    // Record a viewed word
    func recordWordViewed() {
        wordsViewedToday += 1
        print("DailyGoalTracker: Recorded word, new count: \(wordsViewedToday)")

        // Check if daily goal is reached
        if wordsViewedToday >= dailyGoal && !hasReachedGoalToday {
            hasReachedGoalToday = true
            lastCompletionDate = Date()
            updateStreak()
            print("DailyGoalTracker: Daily goal reached! Streak: \(streakDays)")
        }

        saveProgress()
    }

    // Update streak based on completion dates
    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())

        if let lastDate = lastCompletionDate {
            let lastDay = Calendar.current.startOfDay(for: lastDate)

            // Check if this is a new day
            if today != lastDay {
                let components = Calendar.current.dateComponents([.day], from: lastDay, to: today)

                if components.day == 1 {
                    // Consecutive day
                    streakDays += 1
                    if streakDays > bestStreak {
                        bestStreak = streakDays
                    }
                } else if components.day ?? 0 > 1 {
                    // Streak broken
                    streakDays = 1
                }
            }
        }

        saveProgress()
    }

    // Reset daily progress (called at the start of a new day)
    func resetDailyProgress() {
        wordsViewedToday = 0
        hasReachedGoalToday = false
        UserDefaultsManager.shared.saveWordsViewedToday(0)
        UserDefaultsManager.shared.saveLastViewedDate(Date())
    }

    // Check if daily goal is reached
    func isDailyGoalReached() -> Bool {
        return wordsViewedToday >= dailyGoal
    }

    // Get progress percentage
    func getProgressPercentage() -> Double {
        return min(Double(wordsViewedToday) / Double(dailyGoal), 1.0)
    }
}

// MARK: - Enhanced Daily Goal Progress View
struct EnhancedDailyGoalProgressView: View {
    @ObservedObject var goalTracker: DailyGoalTracker
    @State private var showAnimation = false

    var body: some View {
        VStack(spacing: 16) {
            // Progress header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Goal")
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    Text("\(goalTracker.wordsViewedToday)/\(goalTracker.dailyGoal) words")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                        .animation(.spring(), value: goalTracker.wordsViewedToday)
                }

                Spacer()

                // Streak indicator
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)

                    Text("\(goalTracker.streakDays)")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                        .animation(.spring(), value: goalTracker.streakDays)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.cardBackground)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
            }

            // Progress bar
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(Color.gray.opacity(0.2))
                    .cornerRadius(5)

                // Progress
                Rectangle()
                    .frame(
                        width: CGFloat(goalTracker.getProgressPercentage())
                            * UIScreen.main.bounds.width - 40, height: 10
                    )
                    .foregroundColor(progressColor)
                    .cornerRadius(5)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.7),
                        value: goalTracker.wordsViewedToday)

                // Milestone markers
                ForEach(1..<goalTracker.dailyGoal, id: \.self) { milestone in
                    if milestone % (max(goalTracker.dailyGoal / 5, 1)) == 0 {
                        Rectangle()
                            .frame(width: 2, height: 14)
                            .foregroundColor(Color.white.opacity(0.7))
                            .offset(
                                x: CGFloat(Double(milestone) / Double(goalTracker.dailyGoal))
                                    * (UIScreen.main.bounds.width - 40))
                    }
                }
            }

            // Goal completion indicator
            if goalTracker.hasReachedGoalToday {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)

                    Text("Daily goal completed!")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                .padding(.vertical, 4)
                .opacity(showAnimation ? 1 : 0)
                .scaleEffect(showAnimation ? 1 : 0.8)
                .onAppear {
                    withAnimation(.spring()) {
                        showAnimation = true
                    }
                }
            }
        }
        .padding(.horizontal)
        .onChange(of: goalTracker.hasReachedGoalToday) { hasReached in
            if hasReached {
                withAnimation(.spring()) {
                    showAnimation = true
                }
            }
        }
    }

    private var progressColor: Color {
        let progress = goalTracker.getProgressPercentage()

        if progress >= 1.0 {
            return .green
        } else if progress >= 0.7 {
            return .yellow
        } else {
            return .primary
        }
    }
}

// MARK: - Goal Completion Animation
struct GoalCompletionAnimation: View {
    @Binding var isShowing: Bool
    @State private var animateConfetti = false

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                    }
                }

            VStack(spacing: 24) {
                // Trophy icon
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.yellow)
                    .shadow(color: .yellow.opacity(0.5), radius: 10, x: 0, y: 0)
                    .scaleEffect(animateConfetti ? 1.0 : 0.1)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6), value: animateConfetti)

                // Congratulations text
                Text("Daily Goal Achieved!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.primary.opacity(0.8))
                    )
                    .opacity(animateConfetti ? 1.0 : 0.0)
                    .animation(.easeIn.delay(0.3), value: animateConfetti)

                Text("You've reached your daily vocabulary goal! Keep up the great work!")
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(animateConfetti ? 1.0 : 0.0)
                    .animation(.easeIn.delay(0.5), value: animateConfetti)

                // Continue button
                Button(action: {
                    SoundManager.shared.playButtonSound()
                    HapticFeedbackManager.shared.playSelection()
                    withAnimation {
                        isShowing = false
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .opacity(animateConfetti ? 1.0 : 0.0)
                .animation(.easeIn.delay(0.7), value: animateConfetti)
            }
            .padding()

            // Confetti
            ConfettiView()
                .opacity(animateConfetti ? 1.0 : 0.0)
        }
        .opacity(isShowing ? 1.0 : 0.0)
        .animation(.easeIn, value: isShowing)
        .onChange(of: isShowing) { newValue in
            if newValue {
                // Play sound and haptic feedback
                SoundManager.shared.playSuccessSound()
                HapticFeedbackManager.shared.playDailyGoalPattern()

                // Start animations
                withAnimation {
                    animateConfetti = true
                }
            } else {
                // Reset animations
                animateConfetti = false
            }
        }
    }
}

// MARK: - Integration with Main View
struct DailyGoalIntegration: View {
    @StateObject private var goalTracker = DailyGoalTracker()
    @State private var showGoalCompletion = false
    @ObservedObject var wordViewModel: WordCardViewModel

    var body: some View {
        VStack {
            // Daily goal progress view
            EnhancedDailyGoalProgressView(goalTracker: goalTracker)
                .padding(.top)
                .animation(.spring(), value: goalTracker.wordsViewedToday)

            // Word cards view
            EnhancedCardStackView(viewModel: wordViewModel)
                .onChange(of: wordViewModel.wordsViewedToday) { newCount in
                    // Update goal tracker
                    goalTracker.recordWordViewed()

                    // Check if goal was just reached
                    if goalTracker.isDailyGoalReached() && !showGoalCompletion
                        && !goalTracker.hasReachedGoalToday
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showGoalCompletion = true
                        }
                    }
                }
        }
        .overlay(
            GoalCompletionAnimation(isShowing: $showGoalCompletion)
        )
        .onReceive(NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)) {
            _ in
            // Force update when UserDefaults change
            goalTracker.objectWillChange.send()
        }
    }
}
