import SwiftUI

struct SeasonRevealView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState
    @State private var showDeepDive = false
    @State private var showWallet = false
    @State private var fanResolved = false

    let demoSeason: Season = .deepAutumn

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()

                ColorFanReveal(swatches: [], isBlurred: false)
                    .frame(height: 200)
                    .padding(.top, 40)

                Text(demoSeason.rawValue)
                    .font(.custom("Fraunces", size: 34))
                    .foregroundColor(Color(hex: "#F7F2EC"))

                HStack(spacing: 8) {
                    Circle()
                        .fill(themeManager.accentSafeColor)
                        .frame(width: 8, height: 8)
                    Text("92% confidence")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(themeManager.accentSafeColor)
                }

                Text("Warm, rich, and earthy — rust, amber, moss green,\nand deep gold define your palette.")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .multilineTextAlignment(.center)

                Spacer()

                HStack(spacing: 12) {
                    Button(action: { showDeepDive = true }) {
                        Text("Learn More")
                            .font(.custom("Inter", size: 15))
                            .foregroundColor(Color(hex: "#F7F2EC"))
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#2A2729"))
                            .cornerRadius(12)
                    }

                    Button(action: {
                        showWallet = true
                        navigationState.hasCompletedOnboarding = true
                        navigationState.currentAnalysisState = .completed
                    }) {
                        Text("My Wallet")
                            .font(.custom("Inter", size: 15))
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(themeManager.accentSafeColor)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            themeManager.isPreReveal = false
        }
        .fullScreenCover(isPresented: $showDeepDive) {
            SeasonDeepDiveView()
        }
        .fullScreenCover(isPresented: $showWallet) {
            MainTabView()
        }
    }
}
