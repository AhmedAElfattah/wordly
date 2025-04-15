import SwiftUI

@main
struct wordlyApp: App {
  @StateObject private var appState = AppState()
  
  var body: some Scene {
      WindowGroup {
          if appState.hasCompletedOnboarding {
              EnhancedHomeView()
                  .environmentObject(appState)
          } else {
            EnhancedOnboardingView()
                  .environmentObject(appState)
          }
      }
  }
}
