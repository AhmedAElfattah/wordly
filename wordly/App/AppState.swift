import Foundation
import SwiftUI
import Combine

// MARK: - App State
final class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool
    @Published var words: [Word] = []
    @Published var primaryWordViewModel: WordCardViewModel?
    @Published var userPreferences: UserPreferences
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Load onboarding status
        self.hasCompletedOnboarding = UserDefaultsManager.shared.isOnboardingCompleted()
        
        // Initialize user preferences
        self.userPreferences = UserPreferences(
            dailyGoal: UserDefaultsManager.shared.getDailyGoal(),
            selectedCategories: UserDefaultsManager.shared.getSelectedCategories()
        )
        
        // Load words for selected categories
        loadWordsForCategories(userPreferences.selectedCategories)
        
        // Setup observers
        setupObservers()
    }
    
    private func setupObservers() {
        // Listen for UserDefaults changes
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.refreshUserPreferences()
            }
            .store(in: &cancellables)
    }
    
    private func refreshUserPreferences() {
        let dailyGoal = UserDefaultsManager.shared.getDailyGoal()
        let categories = UserDefaultsManager.shared.getSelectedCategories()
        
        // Only update if values have changed
        if dailyGoal != userPreferences.dailyGoal || Set(categories) != Set(userPreferences.selectedCategories) {
            userPreferences = UserPreferences(
                dailyGoal: dailyGoal,
                selectedCategories: categories
            )
            
            // Update primary view model
            primaryWordViewModel?.dailyGoal = dailyGoal
        }
    }
    
    func loadWordsForCategories(_ categories: [WordCategory]) {
        // Get words from provider
        words = WordProvider.shared.getWords(for: categories)
        
        // Initialize primary view model if needed
        if primaryWordViewModel == nil {
            primaryWordViewModel = WordCardViewModel(words: words)
        } else {
            // Update existing view model
            primaryWordViewModel?.words = words
            primaryWordViewModel?.resetToFirstWord()
        }
        
        // Save selected categories
        userPreferences.selectedCategories = categories
        UserDefaultsManager.shared.saveSelectedCategories(categories)
    }
    
    func setDailyGoal(_ goal: Int) {
        userPreferences.dailyGoal = goal
        UserDefaultsManager.shared.saveDailyGoal(goal)
        primaryWordViewModel?.dailyGoal = goal
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaultsManager.shared.setOnboardingCompleted(true)
    }
}

// MARK: - User Preferences
struct UserPreferences {
    var dailyGoal: Int
    var selectedCategories: [WordCategory]
}
