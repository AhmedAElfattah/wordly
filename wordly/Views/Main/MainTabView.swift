import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var goalTracker = DailyGoalViewModel()

    var body: some View {
        TabView {
            MainAppView()
                .environmentObject(appState)
                .environmentObject(goalTracker)
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
                .environmentObject(goalTracker)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(.primary)
        .onAppear {
            // Sync goal tracker with app state
            goalTracker.dailyGoal = appState.userPreferences.dailyGoal
        }
    }
}
