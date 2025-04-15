import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void
    @State private var animateLogo = false
    @State private var animateText = false

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Animated logo
            ZStack {
                Circle()
                    .fill(Color.primary.opacity(0.15))
                    .frame(width: 160, height: 160)

                Circle()
                    .fill(Color.primary.opacity(0.3))
                    .frame(width: 120, height: 120)

                Text("W")
                    .font(.system(size: 80, weight: .black, design: .default))
                    .foregroundColor(.primary)
                    .offset(y: animateLogo ? 0 : 10)
                    .opacity(animateLogo ? 1 : 0)
            }
            .scaleEffect(animateLogo ? 1 : 0.8)
            .opacity(animateLogo ? 1 : 0)

            VStack(spacing: 16) {
                Text("WORDLY")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.textPrimary)
                    .tracking(5)
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 20)

                Text("Expand your vocabulary with elegance")
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .opacity(animateText ? 1 : 0)
                    .offset(y: animateText ? 0 : 15)
            }

            Spacer()

            // Get started button
            Button(action: onContinue) {
                Text("BEGIN YOUR JOURNEY")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primary, Color.primary.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color.primary.opacity(0.5), radius: 10, x: 0, y: 5)
                    .padding(.horizontal, 32)
            }
            .padding(.bottom, 50)
            .opacity(animateText ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                // Background design elements
                Color.background

                // Decorative circles
                Circle()
                    .fill(Color.primary.opacity(0.05))
                    .frame(width: 200, height: 200)
                    .position(
                        x: UIScreen.main.bounds.width * 0.8, y: UIScreen.main.bounds.height * 0.2)

                Circle()
                    .fill(Color.accent.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .position(
                        x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height * 0.8)
            }
            .ignoresSafeArea()
        )
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                animateLogo = true
            }

            withAnimation(.easeOut(duration: 1).delay(0.6)) {
                animateText = true
            }
        }
    }
}

struct DifficultySelectionView: View {
    @Binding var selectedDifficulty: DifficultyLevel
    let onContinue: () -> Void
    let onBack: () -> Void
    @State private var animateContent = false

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Text("Choose Your Path")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)

                Text("Select a difficulty level that matches your vocabulary skills")
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 20)

            // Difficulty selection
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(DifficultyLevel.allCases) { difficulty in
                        DifficultyCard(
                            difficulty: difficulty,
                            isSelected: selectedDifficulty == difficulty,
                            action: {
                                HapticFeedbackManager.shared.playSelection()
                                selectedDifficulty = difficulty
                            }
                        )
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(
                            .easeOut(duration: 0.4)
                                .delay(0.1 + Double(difficulty.rawValue.count % 3) * 0.1),
                            value: animateContent
                        )
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            // Progress indicator
            ProgressIndicator(currentStep: 1, totalSteps: 4)
                .padding(.bottom, 8)
                .opacity(animateContent ? 1 : 0)

            // Navigation buttons
            HStack(spacing: 20) {
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                    .padding(.vertical, 18)
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
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primary, Color.primary.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
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

struct DifficultyCard: View {
    let difficulty: DifficultyLevel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon based on difficulty
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.primary.opacity(0.2) : Color.cardBackground)
                        .frame(width: 50, height: 50)

                    Image(systemName: difficultyIcon(for: difficulty))
                        .font(.title3)
                        .foregroundColor(isSelected ? Color.primary : Color.textSecondary)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(difficulty.rawValue)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .textPrimary : .textSecondary)

                    Text(difficulty.description)
                        .font(.caption)
                        .foregroundColor(isSelected ? .textSecondary : .textSecondary.opacity(0.7))
                        .lineLimit(2)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.primary)
                        .font(.headline)
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected
                            ? Color.cardBackground.opacity(0.7) : Color.cardBackground.opacity(0.3))
            )
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
                y: isSelected ? 5 : 2
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func difficultyIcon(for difficulty: DifficultyLevel) -> String {
        switch difficulty {
        case .beginner:
            return "leaf"
        case .intermediate:
            return "book"
        case .advanced:
            return "star"
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
        GridItem(.flexible()),
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
    @State private var animateContent = false
    @State private var pulseCheckmark = false

    var body: some View {
        ZStack {
            // Background with animated gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.background,
                    Color.background,
                    Color.primary.opacity(0.2),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Decorative elements
            VStack {
                ForEach(0..<20) { i in
                    Circle()
                        .fill(Color.primary.opacity(0.05))
                        .frame(width: CGFloat.random(in: 10...50))
                        .offset(
                            x: CGFloat.random(
                                in: -UIScreen.main.bounds.width...UIScreen.main.bounds.width),
                            y: CGFloat.random(
                                in: -UIScreen.main.bounds.height...UIScreen.main.bounds.height)
                        )
                        .opacity(animateContent ? 1 : 0)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 4...7))
                                .repeatForever(autoreverses: true)
                                .delay(Double.random(in: 0...3)),
                            value: animateContent
                        )
                }
            }
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Animated checkmark success
                ZStack {
                    Circle()
                        .fill(Color.primary.opacity(0.15))
                        .frame(width: 160, height: 160)
                        .scaleEffect(pulseCheckmark ? 1.2 : 1.0)

                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.primary, Color.primary.opacity(0.8),
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)

                    Image(systemName: "checkmark")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                .opacity(animateContent ? 1 : 0)
                .scaleEffect(animateContent ? 1 : 0.5)

                VStack(spacing: 16) {
                    Text("You're All Set!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)

                    Text(
                        "Your personalized wordly experience is ready. Swipe through words to learn and expand your vocabulary."
                    )
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 15)
                }

                Spacer()

                // Begin journey button
                Button(action: onComplete) {
                    HStack {
                        Text("BEGIN YOUR JOURNEY")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.primary, Color.primary.opacity(0.8),
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.primary.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 32)
                }
                .opacity(animateContent ? 1 : 0)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }

            // Start pulsing animation for checkmark
            withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseCheckmark = true
            }
        }
    }
}
