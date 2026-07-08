import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var themeManager: ThemeManager
    @State private var textAppeared = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            KaleidoscopeView()
                .opacity(0.4)

            VStack(spacing: 20) {
                Spacer()

                Text("Hue Tone")
                    .font(.custom("Fraunces", size: 14))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .tracking(4)
                    .opacity(textAppeared ? 0.6 : 0)
                    .offset(y: textAppeared ? 0 : 10)

                Text("Somewhere in\nevery color is\nyours.")
                    .font(.custom("Fraunces", size: 36))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(textAppeared ? 1 : 0)
                    .offset(y: textAppeared ? 0 : 15)

                Text("Take a photo. We'll find the palette\nthat was always yours.")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .multilineTextAlignment(.center)
                    .opacity(textAppeared ? 0.8 : 0)
                    .offset(y: textAppeared ? 0 : 10)

                Spacer()

                Button(action: { navigationState.currentAnalysisState = .capturing }) {
                    Text("Find my colors")
                        .font(.custom("Inter", size: 17, relativeTo: .body))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(themeManager.accentSafeColor)
                        .cornerRadius(12)
                }
                .pressable()
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .opacity(textAppeared ? 1 : 0)
                .offset(y: textAppeared ? 0 : 20)
            }
        }
        .animation(.easeOut(duration: 0.8).delay(0.3), value: textAppeared)
        .onAppear { textAppeared = true }
        .fullScreenCover(isPresented: .init(
            get: { navigationState.currentAnalysisState == .capturing },
            set: { if !$0 { navigationState.currentAnalysisState = .notStarted } }
        )) {
            HowItWorksView()
        }
    }
}
