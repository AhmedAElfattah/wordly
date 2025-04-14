import Combine
import Foundation
import SwiftUI

class AppState: ObservableObject {
    // UserDefaults keys
    private enum UserDefaultsKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let userPreferences = "userPreferences"
        static let dailyGoal = "dailyGoal"
        static let selectedCategories = "selectedCategories"
    }

    @Published private(set) var hasCompletedOnboarding: Bool
    @Published private(set) var userPreferences: UserPreferences
    @Published private(set) var words: [Word]
    @Published private(set) var wordViewModels: [WordCardViewModel]

    var primaryWordViewModel: WordCardViewModel? {
        wordViewModels.first
    }

    init() {
        // Initialize properties with default values first
        self.hasCompletedOnboarding = false
        self.userPreferences = UserPreferences()
        self.words = []
        self.wordViewModels = []

        // Then load from UserDefaults
        self.hasCompletedOnboarding = UserDefaults.standard.bool(
            forKey: UserDefaultsKeys.hasCompletedOnboarding)

        if let savedPreferencesData = UserDefaults.standard.data(
            forKey: UserDefaultsKeys.userPreferences),
            let decodedPreferences = try? JSONDecoder().decode(
                UserPreferences.self, from: savedPreferencesData)
        {
            self.userPreferences = decodedPreferences
        }

        setupInitialWordViewModel()
    }

    private func setupInitialWordViewModel() {
        let defaultWords = CategoryWordSets.getWordsForCategories([.everyday])
        let viewModel = WordCardViewModel(words: defaultWords)
        wordViewModels = [viewModel]
        words = defaultWords
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasCompletedOnboarding)
    }

    func setDailyGoal(_ goal: Int) {
        var updatedPreferences = userPreferences
        updatedPreferences.dailyGoal = goal
        userPreferences = updatedPreferences

        wordViewModels.forEach { viewModel in
            viewModel.dailyGoal = goal
        }
    }

    func loadWordsForCategories(_ categories: [WordCategory]) {
        words = CategoryWordSets.getWordsForCategories(categories)
        let viewModel = WordCardViewModel(words: words)
        viewModel.dailyGoal = userPreferences.dailyGoal
        wordViewModels = [viewModel]
    }

    func loadCategoryBasedWords() {
        let categories = userPreferences.selectedCategories
        words = CategoryWordSets.getWordsForCategories(categories)
        
        wordViewModels.forEach { viewModel in
            viewModel.words = words
        }
    }
}
