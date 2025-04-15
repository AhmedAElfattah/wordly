import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("V")
                .font(.system(size: 80, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.cardBackground)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
            
            Text("VOCABULARY APP")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("Expand your vocabulary with just a few minutes each day.")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
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
        .background(Color.background)
    }
}

struct DifficultySelectionView: View {
    @Binding var selectedDifficulty: DifficultyLevel
    let onContinue: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Your Difficulty")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .padding(.top)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(DifficultyLevel.allCases) { difficulty in
                        DifficultyCard(
                            difficulty: difficulty,
                            isSelected: selectedDifficulty == difficulty,
                            action: {
                                HapticFeedbackManager.shared.playSelection()
                                selectedDifficulty = difficulty
                            }
                        )
                    }
                }
                .padding()
            }
            
            Spacer()
            
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

struct DifficultyCard: View {
    let difficulty: DifficultyLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(difficulty.rawValue)
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .textPrimary)
                    
                    Text(difficulty.description)
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
            Text("Choose Categories")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("Select multiple")
                .font(.subheadline)
                .foregroundColor(.textSecondary)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(WordCategory.allCases, id: \.id) { category in
                        CategoryCard(
                            category: category,
                            isSelected: isCategorySelected(category),
                            action: {
                                HapticFeedbackManager.shared.playSelection()
                                toggleCategory(category)
                            }
                        )
                    }
                }
                .padding()
            }
            
            Spacer()
            
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
        .background(Color.background)
    }
}

struct CategoryCard: View {
    let category: WordCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: categoryIcon(for: category))
                    .font(.system(size: 30))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(category.rawValue)
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : .textPrimary)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
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
    
    private func categoryIcon(for category: WordCategory) -> String {
        switch category {
        case .science:
            return "flask"
        case .business:
            return "briefcase"
        case .arts:
            return "paintbrush"
        case .technology:
            return "desktopcomputer"
        case .academic:
            return "book"
        case .everyday:
            return "house"
        }
    }
}

struct OnboardingCompletionView: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.primary)
            
            Text("You're All Set!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            Text("You'll see a new word each time you swipe. Swipe through to learn and expand your vocabulary.")
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
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
        .background(Color.background)
    }
}
