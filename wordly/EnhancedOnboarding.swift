import SwiftUI

struct EnhancedOnboardingView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = EnhancedOnboardingViewModel()

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack {
                switch viewModel.currentStep {
                case .welcome:
                    WelcomeView(onContinue: {
                        SoundManager.shared.playButtonSound()
                        viewModel.moveToNextStep()
                    })
                case .difficultySelection:
                    DifficultySelectionView(
                        selectedDifficulty: $viewModel.selectedDifficulty,
                        onContinue: {
                            SoundManager.shared.playButtonSound()
                            viewModel.moveToNextStep()
                        },
                        onBack: {
                            SoundManager.shared.playButtonSound()
                            viewModel.moveToPreviousStep()
                        }
                    )
                case .categorySelection:
                    CategorySelectionView(
                        selectedCategories: $viewModel.selectedCategories,
                        onContinue: {
                            SoundManager.shared.playButtonSound()
                            viewModel.moveToNextStep()
                        },
                        onBack: {
                            SoundManager.shared.playButtonSound()
                            viewModel.moveToPreviousStep()
                        },
                        isCategorySelected: viewModel.isCategorySelected,
                        toggleCategory: viewModel.toggleCategory,
                        canProceed: viewModel.canProceedFromCategorySelection()
                    )
                case .dailyGoalSetting:
                    DailyGoalSettingView(
                        selectedGoal: $viewModel.selectedDailyGoal,
                        onContinue: {
                            SoundManager.shared.playButtonSound()
                            viewModel.moveToNextStep()
                        },
                        onBack: {
                            SoundManager.shared.playButtonSound()
                            viewModel.moveToPreviousStep()
                        }
                    )
                case .completion:
                    OnboardingCompletionView(onComplete: {
                        SoundManager.shared.playSuccessSound()
                        HapticFeedbackManager.shared.playSuccessPattern()
                        // Update app state with user preferences
                        appState.userPreferences = viewModel.getUserPreferences()
                        // Load words based on selected categories
                        appState.loadWordsForCategories(Array(viewModel.selectedCategories))
                        // Set daily goal
                        appState.setDailyGoal(viewModel.selectedDailyGoal)
                        // Complete onboarding
                        appState.completeOnboarding()
                    })
                }
            }
            .padding()
            .background(Color.background)
        }
    }
}

class EnhancedOnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var selectedDifficulty: DifficultyLevel = .intermediate
    @Published var selectedCategories: Set<WordCategory> = []
    @Published var selectedDailyGoal: Int = 10

    enum OnboardingStep {
        case welcome
        case difficultySelection
        case categorySelection
        case dailyGoalSetting
        case completion
    }

    func moveToNextStep() {
        switch currentStep {
        case .welcome:
            currentStep = .difficultySelection
        case .difficultySelection:
            currentStep = .categorySelection
        case .categorySelection:
            currentStep = .dailyGoalSetting
        case .dailyGoalSetting:
            currentStep = .completion
        case .completion:
            // This is handled by the view to complete onboarding
            break
        }
    }

    func moveToPreviousStep() {
        switch currentStep {
        case .welcome:
            // Already at first step
            break
        case .difficultySelection:
            currentStep = .welcome
        case .categorySelection:
            currentStep = .difficultySelection
        case .dailyGoalSetting:
            currentStep = .categorySelection
        case .completion:
            currentStep = .dailyGoalSetting
        }
    }

    func selectDifficulty(_ difficulty: DifficultyLevel) {
        selectedDifficulty = difficulty
    }

    func toggleCategory(_ category: WordCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }

    func isCategorySelected(_ category: WordCategory) -> Bool {
        return selectedCategories.contains(category)
    }

    func canProceedFromCategorySelection() -> Bool {
        return !selectedCategories.isEmpty
    }

    func getUserPreferences() -> UserPreferences {
        return UserPreferences(
            difficultyLevel: selectedDifficulty,
            selectedCategories: Array(selectedCategories),
            dailyGoal: selectedDailyGoal
        )
    }
}

struct DailyGoalSettingView: View {
    @Binding var selectedGoal: Int
    let onContinue: () -> Void
    let onBack: () -> Void

    let goalOptions = [5, 10, 15, 20, 25]

    var body: some View {
        VStack(spacing: 20) {
            Text("Set Your Daily Goal")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .padding(.top)

            Text("How many words would you like to learn each day?")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(goalOptions, id: \.self) { goal in
                        DailyGoalCard(
                            goal: goal,
                            isSelected: selectedGoal == goal,
                            action: {
                                SoundManager.shared.playButtonSound()
                                selectedGoal = goal
                            }
                        )
                    }
                }
                .padding()
            }

            Spacer()

            // Progress indicator
            ProgressIndicator(currentStep: 3, totalSteps: 4)
                .padding(.bottom)

            HStack {
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.cardBackground)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }

                Button(action: onContinue) {
                    HStack {
                        Text("Continue")
                        Image(systemName: "chevron.right")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primary)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.background)
    }
}

struct DailyGoalCard: View {
    let goal: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(goal) Words")
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .textPrimary)

                    Text(goalDescription(for: goal))
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .textSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.primary : Color.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.primary : Color.gray.opacity(0.2), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func goalDescription(for goal: Int) -> String {
        switch goal {
        case 5:
            return "Perfect for busy days"
        case 10:
            return "Recommended for most users"
        case 15:
            return "For dedicated learners"
        case 20:
            return "For serious vocabulary building"
        case 25:
            return "For vocabulary enthusiasts"
        default:
            return ""
        }
    }
}

// Update the UserPreferences model to include daily goal
struct UserPreferences {
    var difficultyLevel: DifficultyLevel = .intermediate
    var selectedCategories: [WordCategory] = []
    var dailyGoal: Int = 10
}
