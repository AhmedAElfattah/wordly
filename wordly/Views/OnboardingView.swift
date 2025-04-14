import SwiftUI

struct OnboardingView: View {
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
                        HapticFeedbackManager.shared.playLightTap()
                        viewModel.moveToNextStep()
                    })
                case .difficultySelection:
                    DifficultySelectionView(
                        selectedDifficulty: $viewModel.selectedDifficulty,
                        onContinue: {
                            SoundManager.shared.playButtonSound()
                            HapticFeedbackManager.shared.playLightTap()
                            viewModel.moveToNextStep()
                        },
                        onBack: {
                            SoundManager.shared.playButtonSound()
                            HapticFeedbackManager.shared.playLightTap()
                            viewModel.moveToPreviousStep()
                        }
                    )
                case .categorySelection:
                    CategorySelectionView(
                        selectedCategories: $viewModel.selectedCategories,
                        onContinue: {
                            SoundManager.shared.playButtonSound()
                            HapticFeedbackManager.shared.playLightTap()
                            viewModel.moveToNextStep()
                        },
                        onBack: {
                            SoundManager.shared.playButtonSound()
                            HapticFeedbackManager.shared.playLightTap()
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
                            HapticFeedbackManager.shared.playLightTap()
                            viewModel.moveToNextStep()
                        },
                        onBack: {
                            SoundManager.shared.playButtonSound()
                            HapticFeedbackManager.shared.playLightTap()
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

struct WelcomeView: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // App logo
            Image(systemName: "textformat.abc")
                .font(.system(size: 80))
                .foregroundColor(.primary)
                .padding()
                .background(
                    Circle()
                        .fill(Color.cardBackground)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
            
            // Welcome text
            Text("Welcome to Wordly")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            Text("Expand your vocabulary with just a few minutes each day")
                .font(.title3)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // Get started button
            Button(action: onContinue) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primary)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct DifficultySelectionView: View {
    @Binding var selectedDifficulty: DifficultyLevel
    let onContinue: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Difficulty")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .padding(.top)
            
            Text("Choose a difficulty level that matches your vocabulary knowledge")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(DifficultyLevel.allCases, id: \.self) { difficulty in
                        DifficultyCard(
                            difficulty: difficulty,
                            isSelected: selectedDifficulty == difficulty,
                            action: {
                                SoundManager.shared.playButtonSound()
                                HapticFeedbackManager.shared.playLightTap()
                                selectedDifficulty = difficulty
                            }
                        )
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Progress indicator
            ProgressIndicator(currentStep: 1, totalSteps: 4)
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
    }
}

struct DifficultyCard: View {
    let difficulty: DifficultyLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(difficulty.description)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .textPrimary)
                    
                    Text(difficultyDescription(for: difficulty))
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
    
    private func difficultyDescription(for difficulty: DifficultyLevel) -> String {
        switch difficulty {
        case .beginner:
            return "Common words for everyday use"
        case .intermediate:
            return "Expand your vocabulary with more nuanced words"
        case .advanced:
            return "Sophisticated and specialized vocabulary"
        }
    }
}

struct CategorySelectionView: View {
    @Binding var selectedCategories: Set<WordCategory>
    let onContinue: () -> Void
    let onBack: () -> Void
    let isCategorySelected: (WordCategory) -> Bool
    let toggleCategory: (WordCategory) -> Void
    let canProceed: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Categories")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .padding(.top)
            
            Text("Choose categories that interest you")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(WordCategory.allCases, id: \.self) { category in
                        CategoryCard(
                            category: category,
                            isSelected: isCategorySelected(category),
                            action: {
                                SoundManager.shared.playButtonSound()
                                HapticFeedbackManager.shared.playLightTap()
                                toggleCategory(category)
                            }
                        )
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Progress indicator
            ProgressIndicator(currentStep: 2, totalSteps: 4)
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
                    .background(canProceed ? Color.primary : Color.gray)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .disabled(!canProceed)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct CategoryCard: View {
    let category: WordCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.system(size: 30))
                    .foregroundColor(isSelected ? .white : .primary)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.primary : Color.cardBackground)
                    )
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.primary : Color.gray.opacity(0.2), lineWidth: 2)
                    )
                
                Text(category.description)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.primary : Color.gray.opacity(0.2), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
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
                                HapticFeedbackManager.shared.playLightTap()
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

struct OnboardingCompletionView: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Success icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
                .padding()
            
            // Completion text
            Text("You're All Set!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            Text("Your personalized vocabulary journey is ready to begin")
                .font(.title3)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            // Progress indicator
            ProgressIndicator(currentStep: 4, totalSteps: 4)
                .padding(.bottom)
            
            // Start learning button
            Button(action: onComplete) {
                Text("Start Learning")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primary)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct ProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                Circle()
                    .fill(step <= currentStep ? Color.primary : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
}
