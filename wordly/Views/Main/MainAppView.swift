import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var goalTracker: DailyGoalViewModel
    @State private var showGoalCompletion = false
    @State private var showQuiz = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea()

                VStack {
                    // App header
                    HStack {
                        Text("Vocabulary")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)

                        Spacer()

                        // Quiz button
                        Button(action: {
                            showQuiz = true
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .padding(8)
                                .background(Circle().fill(Color.cardBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // Daily goal progress
                    DailyGoalProgressView(goalTracker: goalTracker)
                        .padding(.top, 8)

                    // Main content - Horizontal scrolling word cards
                    if let viewModel = appState.primaryWordViewModel {
                        CardStackView(viewModel: viewModel)
                            .onChange(of: viewModel.wordsViewedToday) { newCount in

                                if goalTracker.isDailyGoalReached() {
                                    return
                                }
                                // Sync the goal tracker's count with the viewModel
                                if newCount > goalTracker.wordsViewedToday {
                                    // Increment by the difference
                                    let countToAdd = newCount - goalTracker.wordsViewedToday
                                    for _ in 0..<countToAdd {
                                        goalTracker.recordWordViewed()
                                    }
                                } else if newCount < goalTracker.wordsViewedToday {
                                    // If the count decreased, sync them
                                    goalTracker.wordsViewedToday = newCount
                                }

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
                }

                GoalCompletionView(isShowing: $showGoalCompletion)

            }
            .onAppear {
                // Initialize the app and sync the goal tracker
                if let viewModel = appState.primaryWordViewModel {
                    // Set daily goals
                    viewModel.dailyGoal = appState.userPreferences.dailyGoal
                    goalTracker.dailyGoal = appState.userPreferences.dailyGoal

                    // Sync word counts between the models
                    if viewModel.wordsViewedToday != goalTracker.wordsViewedToday {
                        // Ensure both counters have the same value
                        let maxCount = max(viewModel.wordsViewedToday, goalTracker.wordsViewedToday)
                        viewModel.wordsViewedToday = maxCount
                        goalTracker.wordsViewedToday = maxCount
                    }

                    // Update goal completion status
                    goalTracker.hasReachedGoalToday = goalTracker.isDailyGoalReached()
                }
            }
            .fullScreenCover(isPresented: $showQuiz) {
                if let viewModel = appState.primaryWordViewModel {
                    QuizView(viewModel: QuizViewModel(words: viewModel.words), isShowing: $showQuiz)
                }
            }
        }
    }
}
