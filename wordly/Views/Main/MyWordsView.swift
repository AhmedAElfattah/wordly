import SwiftUI

struct MyWordsView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedFilter: WordFilter = .all

    enum WordFilter {
        case all, new, learning, familiar, mastered
    }

    var body: some View {
        NavigationView {
            VStack {
                // Filter pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterPill(title: "All", isSelected: selectedFilter == .all) {
                            selectedFilter = .all
                        }

                        FilterPill(title: "New", isSelected: selectedFilter == .new) {
                            selectedFilter = .new
                        }

                        FilterPill(title: "Learning", isSelected: selectedFilter == .learning) {
                            selectedFilter = .learning
                        }

                        FilterPill(title: "Familiar", isSelected: selectedFilter == .familiar) {
                            selectedFilter = .familiar
                        }

                        FilterPill(title: "Mastered", isSelected: selectedFilter == .mastered) {
                            selectedFilter = .mastered
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                // Word list
                List {
                    ForEach(filteredWords) { word in
                        WordRow(word: word)
                            .listRowBackground(Color.cardBackground)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.background)
            }
            .background(Color.background.ignoresSafeArea())
            .navigationTitle("My Vocabulary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var filteredWords: [Word] {
        switch selectedFilter {
        case .all:
            return appState.words
        case .new:
            return appState.words.filter { $0.masteryLevel == .new }
        case .learning:
            return appState.words.filter { $0.masteryLevel == .learning }
        case .familiar:
            return appState.words.filter { $0.masteryLevel == .familiar }
        case .mastered:
            return appState.words.filter { $0.masteryLevel == .mastered }
        }
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.primary : Color.cardBackground)
                .foregroundColor(isSelected ? .white : .textPrimary)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

struct WordRow: View {
    let word: Word

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(word.term)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Text(word.masteryLevel.description)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: word.masteryLevel.color))
                    .cornerRadius(10)
            }

            Text(word.partOfSpeech)
                .font(.caption)
                .foregroundColor(.textSecondary)
                .lineLimit(nil)

            Text(word.definition)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
                .lineLimit(3)
                .padding(.top, 2)
        }
        .padding(.vertical, 8)
    }
}
