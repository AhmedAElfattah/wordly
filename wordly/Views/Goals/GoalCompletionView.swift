import SwiftUI

struct GoalCompletionView: View {
    @Binding var isShowing: Bool
    @State private var animateConfetti = true

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
                    VisualFeedbackManager.shared.playButtonFeedback()
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
        }
        .opacity(isShowing ? 1.0 : 0.0)
        .animation(.easeIn, value: isShowing)
        .onChange(of: isShowing) { newValue in
            if newValue {
                // Play feedback
                VisualFeedbackManager.shared.playVictoryFeedback()
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
