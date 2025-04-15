import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var goalTracker = DailyGoalTracker()
    @State private var showGoalCompletion = false
    @State private var isSoundEnabled = true
    
    var body: some View {
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
           
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Daily goal progress
                EnhancedDailyGoalProgressView(goalTracker: goalTracker)
                    .padding(.top, 8)
                
                // Main content - Vertical scrolling word cards
                if let viewModel = appState.primaryWordViewModel {
                  EnhancedCardStackView(viewModel: viewModel)
                        .onChange(of: viewModel.wordsViewedToday) { newCount in
                            // Update goal tracker
                            goalTracker.recordWordViewed()
                            
                            // Check if goal was just reached
                            if goalTracker.isDailyGoalReached() && !showGoalCompletion && !goalTracker.hasReachedGoalToday {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    showGoalCompletion = true
                                }
                            }
                        }
                }
            }
            
            // Goal completion overlay
            if showGoalCompletion {
                GoalCompletionAnimation(isShowing: $showGoalCompletion)
            }
        }
        .onAppear {
            // Initialize the app
            if let viewModel = appState.primaryWordViewModel {
                viewModel.dailyGoal = appState.userPreferences.dailyGoal
            }
        }
    }
}

// Updated AppState to support all new features
class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var userPreferences: UserPreferences = UserPreferences()
    @Published var words: [Word] = []
    @Published var wordViewModels: [WordCardViewModel] = []
    
    var primaryWordViewModel: WordCardViewModel? {
        return wordViewModels.first
    }
    
    init() {
        // In a real app, we would load this from UserDefaults or a database
        hasCompletedOnboarding = false
        setupInitialWordViewModel()
    }
    
    private func setupInitialWordViewModel() {
        // Create initial word view model with default words
        let viewModel = WordCardViewModel(words: [])
        viewModel.loadWordsForCategories([.everyday]) // Default category
        wordViewModels.append(viewModel)
        words = viewModel.words
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        // In a real app, we would save this to UserDefaults
    }
    
    func setDailyGoal(_ goal: Int) {
        userPreferences.dailyGoal = goal
        
        // Update all view models
        for viewModel in wordViewModels {
            viewModel.dailyGoal = goal
        }
    }
    
    func loadWordsForCategories(_ categories: [WordCategory]) {
        // Clear existing view models
        wordViewModels.removeAll()
        
        // Create a new view model with the filtered words
        let viewModel = WordCardViewModel(words: [])
        viewModel.loadWordsForCategories(categories)
        viewModel.dailyGoal = userPreferences.dailyGoal
        
        // Add to wordViewModels array
        wordViewModels.append(viewModel)
        
        // Update words array
        words = viewModel.words
    }
}

