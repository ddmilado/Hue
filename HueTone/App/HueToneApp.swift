import SwiftUI

@main
struct HueToneApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var navigationState = NavigationState()
    @StateObject private var authService = AuthService.shared
    @State private var launchAnimation = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(navigationState)
                .environmentObject(authService)
                .preferredColorScheme(.dark)
                .opacity(launchAnimation ? 1 : 0)
                .scaleEffect(launchAnimation ? 1 : 0.98)
                .animation(.easeOut(duration: 0.5), value: launchAnimation)
                .onAppear { launchAnimation = true }
        }
    }
}
