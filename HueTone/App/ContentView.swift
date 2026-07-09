import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var themeManager: ThemeManager
    @State private var animateIn = false

    var body: some View {
        Group {
            if navigationState.hasCompletedOnboarding {
                MainTabView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                WelcomeView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.85), value: navigationState.hasCompletedOnboarding)
    }
}

struct MainTabView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        TabView {
            ColorWalletView()
                .tabItem {
                    Label("Wallet", systemImage: "wallet.pass")
                }

            TryItOnView()
                .tabItem {
                    Label("Try On", systemImage: "sparkles.rectangle.stack")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }

            ProfileSettingsView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .tint(themeManager.accentSafeColor)
    }
}
