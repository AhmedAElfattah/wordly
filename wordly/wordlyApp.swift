import SwiftUI

@main
struct wordlyApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(appState)
            } else {
                EnhancedOnboardingView()
                    .environmentObject(appState)
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var goalTracker = DailyGoalTracker()

    var body: some View {
        TabView {
            MainAppView()
                .environmentObject(appState)
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }

            MyWordsView()
                .environmentObject(appState)
                .tabItem {
                    Label("My Words", systemImage: "list.bullet")
                }

            SettingsView()
                .environmentObject(appState)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(.primary)
    }
}

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

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategories: Set<WordCategory> = []
    @State private var dailyGoal: Int = 10
    @State private var isSoundEnabled: Bool = true
    @State private var isHapticEnabled: Bool = true
    @State private var showResetConfirmation = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Daily Goal")) {
                    Picker("Words per day", selection: $dailyGoal) {
                        Text("5").tag(5)
                        Text("10").tag(10)
                        Text("15").tag(15)
                        Text("20").tag(20)
                        Text("25").tag(25)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: dailyGoal) { newValue in
                        appState.setDailyGoal(newValue)
                    }
                }

                Section(header: Text("Word Categories")) {
                    ForEach(WordCategory.allCases) { category in
                        Toggle(
                            category.rawValue,
                            isOn: Binding(
                                get: { selectedCategories.contains(category) },
                                set: { newValue in
                                    if newValue {
                                        selectedCategories.insert(category)
                                    } else {
                                        selectedCategories.remove(category)
                                    }
                                }
                            ))
                    }

                    Button("Apply Changes") {
                        appState.loadWordsForCategories(Array(selectedCategories))
                    }
                    .disabled(selectedCategories.isEmpty)
                }

                Section(header: Text("App Settings")) {
                    Toggle("Sound Effects", isOn: $isSoundEnabled)
                        .onChange(of: isSoundEnabled) { newValue in
                            SoundManager.shared.toggleSound(enabled: newValue)
                        }

                    Toggle("Haptic Feedback", isOn: $isHapticEnabled)
                        .onChange(of: isHapticEnabled) { newValue in
                            // Toggle haptic feedback (would be implemented in a real app)
                        }
                }

                Section {
                    Button("Reset All Progress") {
                        showResetConfirmation = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .alert(isPresented: $showResetConfirmation) {
                Alert(
                    title: Text("Reset Progress"),
                    message: Text(
                        "This will reset all your progress, including mastery levels and streaks. This cannot be undone."
                    ),
                    primaryButton: .destructive(Text("Reset")) {
                        resetAllProgress()
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                // Load current settings
                selectedCategories = Set(appState.userPreferences.selectedCategories)
                dailyGoal = appState.userPreferences.dailyGoal
            }
        }
    }

    private func resetAllProgress() {
        // Reset UserDefaults
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }

        // Reset app state but keep onboarding completed
        UserDefaultsManager.shared.setOnboardingCompleted(true)

        // Reload the app with default settings
        appState.loadWordsForCategories([.everyday])
        appState.setDailyGoal(10)
    }
}
