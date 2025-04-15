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
    @State private var animateContent = false

    let goalOptions = [5, 10, 15, 20, 25]

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 10) {
                Text("Set Your Daily Goal")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text("How many words would you like to learn each day?")
                .font(.title3)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 16)
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 20)

            // Goal selection cards
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(goalOptions, id: \.self) { goal in
                        DailyGoalCard(
                            goal: goal,
                            isSelected: selectedGoal == goal,
                            action: {
                                SoundManager.shared.playButtonSound()
                                selectedGoal = goal
                            }
                        )
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(
                            .easeOut(duration: 0.4)
                                .delay(0.1 + Double(goal % 10) * 0.05),
                            value: animateContent
                        )
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            // Progress indicator
            ProgressIndicator(currentStep: 3, totalSteps: 4)
                .padding(.bottom, 8)
                .opacity(animateContent ? 1 : 0)

            // Navigation buttons
            HStack(spacing: 16) {
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.title3)
                    .foregroundColor(.textSecondary)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(Color.cardBackground)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
                    )
                }

                Button(action: onContinue) {
                    HStack {
                        Text("Continue")
                        Image(systemName: "chevron.right")
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.textPrimary)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primary, Color.primary.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color.primary.opacity(0.3), radius: 6, x: 0, y: 3)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                Color.background

                // Decorative elements
                VStack {
                    Circle()
                        .fill(Color.primary.opacity(0.03))
                        .frame(width: 250, height: 250)
                        .offset(x: UIScreen.main.bounds.width * 0.4, y: -30)

                    Spacer()
                }

                VStack {
                    Spacer()
                    Circle()
                        .fill(Color.accent.opacity(0.03))
                        .frame(width: 200, height: 200)
                        .offset(x: -UIScreen.main.bounds.width * 0.3, y: 0)
                }
            }
            .ignoresSafeArea()
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateContent = true
            }
        }
    }
}

struct DailyGoalCard: View {
    let goal: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Goal number with visual indicator
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.primary.opacity(0.2) : Color.cardBackground)
                        .frame(width: 50, height: 50)

                    Text("\(goal)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isSelected ? Color.primary : Color.textSecondary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(goal) Words")
                    .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .textPrimary : .textSecondary)
                        .lineLimit(1)

                    Text(goalDescription(for: goal))
                    .font(.body)
                        .foregroundColor(isSelected ? .textSecondary : .textSecondary.opacity(0.7))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.primary)
                        .font(.title3)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected
                            ? Color.cardBackground.opacity(0.7) : Color.cardBackground.opacity(0.3))
            )
            // Apply conditional overlay based on selection state
            .overlay(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.primary, Color.accent]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.clear, lineWidth: 2)
                    }
                }
            )
            .shadow(
                color: isSelected ? Color.primary.opacity(0.2) : Color.black.opacity(0.05),
                radius: isSelected ? 10 : 5,
                x: 0,
                y: isSelected ? 4 : 2
            )
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

// MARK: - Goal Selection View
struct GoalSelectionView: View {
    @Binding var selectedGoal: Int
    @Binding var currentStep: EnhancedOnboardingViewModel.OnboardingStep

    let availableGoals = [5, 10, 15, 20, 25]

    var body: some View {
        VStack(spacing: 30) {
            Text("Set Your Daily Goal")
            .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)

            Text("How many words would you like to learn each day?")
            .font(.title3)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)

            // Goal options
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(availableGoals, id: \.self) { goal in
                        GoalOptionCard(
                            goal: goal,
                            description: goalDescription(for: goal),
                            isSelected: selectedGoal == goal,
                            action: { selectedGoal = goal }
                        )
                    }
                }
                .padding(.vertical)
            }

            // Continue button
            Button(action: {
                // Save to UserDefaults
                UserDefaultsManager.shared.saveDailyGoal(selectedGoal)

                // Play selection sound and haptic feedback
                SoundManager.shared.playButtonSound()
                HapticFeedbackManager.shared.playSelection()

                // Move to next step
                withAnimation {
                    currentStep = .completion
                }
            }) {
                Text("Continue")
                .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.ignoresSafeArea())
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

// MARK: - Goal Option Card
struct GoalOptionCard: View {
    let goal: Int
    let description: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            SoundManager.shared.playButtonSound()
            HapticFeedbackManager.shared.playSelection()
            action()
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(goal) words")
                    .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white : .textPrimary)
                        .lineLimit(1)

                    Text(description)
                    .font(.body)
                        .foregroundColor(isSelected ? .white.opacity(0.9) : .textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 6)

                Spacer()

                // Selected indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                        .padding(.leading, 6)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.primary : Color.cardBackground)
            )
            .shadow(
                color: isSelected ? Color.primary.opacity(0.2) : Color.black.opacity(0.05),
                radius: isSelected ? 10 : 5,
                x: 0,
                y: isSelected ? 4 : 2
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
