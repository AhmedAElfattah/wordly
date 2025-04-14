import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var goalTracker = DailyGoalTracker()
    @State private var showGoalCompletion = false
    @State private var isSoundEnabled = true
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                // App header
                HStack {
                    Text("Wordly")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    // Sound toggle
                    SoundToggleView(isSoundEnabled: $isSoundEnabled)
                        .onChange(of: isSoundEnabled) { enabled in
                            SoundManager.shared.toggleSound(enabled: enabled)
                        }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Daily goal progress
                EnhancedDailyGoalProgressView(goalTracker: goalTracker, animatedProgress: $animatedProgress)
                    .padding(.top, 8)
                
                // Main content - Vertical scrolling word cards
                if let viewModel = appState.primaryWordViewModel {
                    EnhancedVerticalCardStackView(viewModel: viewModel)
                        .onChange(of: viewModel.wordsViewedToday) { newCount in
                            // Update goal tracker
                            goalTracker.recordWordViewed()
                            
                            // Safely animate the progress
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                animatedProgress = goalTracker.getProgressPercentage()
                            }
                            
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
            
            // Initialize animated progress
            animatedProgress = goalTracker.getProgressPercentage()
        }
    }
}

struct SoundToggleView: View {
    @Binding var isSoundEnabled: Bool
    
    var body: some View {
        Button(action: {
            isSoundEnabled.toggle()
            HapticFeedbackManager.shared.playSelection()
        }) {
            Image(systemName: isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                .font(.title3)
                .foregroundColor(.primary)
                .padding()
                .background(Circle().fill(Color.cardBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct EnhancedDailyGoalProgressView: View {
    @ObservedObject var goalTracker: DailyGoalTracker
    @Binding var animatedProgress: Double
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
                }
                
                Spacer()
                
                // Streak indicator
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    
                    Text("\(goalTracker.streakDays)")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.cardBackground)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
            }
            
            // Progress bar - FIXED ANIMATION
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                // Progress - Using animatedProgress instead of direct calculation
                Rectangle()
                    .frame(width: max(0, min(CGFloat(animatedProgress) * (UIScreen.main.bounds.width - 40), UIScreen.main.bounds.width - 40)), height: 10)
                    .foregroundColor(progressColor)
                    .cornerRadius(5)
                
                // Milestone markers
                ForEach(1..<goalTracker.dailyGoal, id: \.self) { milestone in
                    if milestone % (goalTracker.dailyGoal / 5) == 0 {
                        Rectangle()
                            .frame(width: 2, height: 14)
                            .foregroundColor(Color.white.opacity(0.7))
                            .offset(x: CGFloat(Double(milestone) / Double(goalTracker.dailyGoal)) * (UIScreen.main.bounds.width - 40))
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
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3)) {
                        showAnimation = true
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private var progressColor: Color {
        let progress = animatedProgress
        
        if progress >= 1.0 {
            return .green
        } else if progress >= 0.7 {
            return .blue
        } else if progress >= 0.4 {
            return .orange
        } else {
            return .red
        }
    }
}

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
