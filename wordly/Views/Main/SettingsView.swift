import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var goalTracker: DailyGoalViewModel
    @State private var selectedCategories: Set<WordCategory> = []
    @State private var dailyGoal: Int = 10
    @State private var isFeedbackEnabled: Bool = true
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
                        goalTracker.dailyGoal = newValue
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
                    Toggle("Visual Feedback", isOn: $isFeedbackEnabled)
                        .onChange(of: isFeedbackEnabled) { newValue in
                            VisualFeedbackManager.shared.toggleFeedback(enabled: newValue)
                        }

                    Toggle("Haptic Feedback", isOn: $isHapticEnabled)
                    
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
        UserDefaultsManager.shared.resetAllProgress()

        // Reload the app with default settings
        appState.loadWordsForCategories([.everyday])
        appState.setDailyGoal(10)
        
        // Reset goal tracker
        goalTracker.resetDailyProgress()
    }
}
