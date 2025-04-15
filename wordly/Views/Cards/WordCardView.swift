import SwiftUI

struct WordCardView: View {
    let word: Word
    @State private var isShowingDefinition = false
    @State private var isShowingExample = false
    @State private var isShowingMastery = false
    @EnvironmentObject private var scrollProxy: ScrollViewProxy

    var body: some View {
        ScrollView(showsIndicators: true) {
            ScrollViewReader { scrollReader in
                VStack(alignment: .leading, spacing: 16) {
                    // Word and pronunciation
                    VStack(alignment: .leading, spacing: 4) {
                        Text(word.term)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.textPrimary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .id("top")

                        Text(word.pronunciation)
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(word.partOfSpeech)
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                    }
                    .opacity(1.0)
                    .padding(.top, 24)

                    // Mastery indicator with animation
                    MasteryIndicatorView(level: word.masteryLevel)
                        .opacity(isShowingMastery ? 1 : 0)
                        .offset(y: isShowingMastery ? 0 : 20)
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.7).delay(0.1),
                            value: isShowingMastery
                        )

                    Divider()

                    // Definition with animation
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Definition")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textSecondary)

                        Text(word.definition)
                            .font(.body)
                            .foregroundColor(.textPrimary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .opacity(isShowingDefinition ? 1 : 0)
                    .offset(y: isShowingDefinition ? 0 : 20)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.7).delay(0.2),
                        value: isShowingDefinition
                    )

                    // Example with animation
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Example")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.textSecondary)

                        Text(word.example)
                            .font(.body)
                            .italic()
                            .foregroundColor(.textSecondary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .opacity(isShowingExample ? 1 : 0)
                    .offset(y: isShowingExample ? 0 : 20)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.7).delay(0.3),
                        value: isShowingExample
                    )

                    // Add extra space at the bottom to push content up
                    Spacer(minLength: 100)
                }
                .padding(20)
                .onChange(of: scrollProxy.scrollToTopTrigger) { _ in
                    withAnimation {
                        scrollReader.scrollTo("top", anchor: .top)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .onAppear {
            // Staggered animations for content
            withAnimation(.easeOut(duration: 0.3)) {
                isShowingMastery = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.3)) {
                    isShowingDefinition = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeOut(duration: 0.3)) {
                    isShowingExample = true
                }
            }
        }
    }
}

struct MasteryIndicatorView: View {
    let level: MasteryLevel

    var body: some View {
        HStack {
            Text(level.description)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(hex: level.color))
                .cornerRadius(10)

            Spacer()
        }
    }
}
