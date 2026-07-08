import SwiftUI

@main
struct HueToneApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var navigationState = NavigationState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .environmentObject(navigationState)
                .preferredColorScheme(.dark)
        }
    }
}
