import SwiftUI

struct DailyGoalProgressView: View {
    @ObservedObject var goalTracker: DailyGoalViewModel
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
                        .animation(.spring(), value: goalTracker.wordsViewedToday)
                }

                Spacer()

                // Streak indicator
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)

                    Text("\(goalTracker.streakDays)")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                        .animation(.spring(), value: goalTracker.streakDays)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.cardBackground)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
            }

            // Progress bar
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(Color.gray.opacity(0.2))
                    .cornerRadius(5)

                // Progress
                Rectangle()
                    .frame(
                        width: CGFloat(goalTracker.getProgressPercentage())
                            * UIScreen.main.bounds.width - 40, height: 10
                    )
                    .foregroundColor(progressColor)
                    .cornerRadius(5)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.7),
                        value: goalTracker.wordsViewedToday)

                // Milestone markers
                ForEach(1..<goalTracker.dailyGoal, id: \.self) { milestone in
                    if milestone % (max(goalTracker.dailyGoal / 5, 1)) == 0 {
                        Rectangle()
                            .frame(width: 2, height: 14)
                            .foregroundColor(Color.white.opacity(0.7))
                            .offset(
                                x: CGFloat(Double(milestone) / Double(goalTracker.dailyGoal))
                                    * (UIScreen.main.bounds.width - 40))
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
                    withAnimation(.spring()) {
                        showAnimation = true
                    }
                }
            }
        }
        .padding(.horizontal)
        .onChange(of: goalTracker.hasReachedGoalToday) { hasReached in
            if hasReached {
                withAnimation(.spring()) {
                    showAnimation = true
                }
            }
        }
    }

    private var progressColor: Color {
        let progress = goalTracker.getProgressPercentage()

        if progress >= 1.0 {
            return .green
        } else if progress >= 0.7 {
            return .yellow
        } else {
            return .primary
        }
    }
}
