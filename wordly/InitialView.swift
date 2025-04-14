import SwiftUI

struct InitialView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        if appState.hasCompletedOnboarding {
            MainView()
                .environmentObject(appState)
        } else {
            OnboardingView()
                .environmentObject(appState)
        }
    }
}
