import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Group {
            if navigationState.hasCompletedOnboarding {
                MainTabView()
            } else {
                WelcomeView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: navigationState.hasCompletedOnboarding)
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

            ShoppingModeView()
                .tabItem {
                    Label("Shop", systemImage: "camera.viewfinder")
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
        .tint(Color(hex: themeManager.signatureAccentSafe))
    }
}
