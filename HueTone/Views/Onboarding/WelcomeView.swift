import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var navigationState: NavigationState

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

                Text("Somewhere in\nevery color is\nyours.")
                    .font(.custom("Fraunces", size: 36))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                Text("Take a photo. We'll find the palette\nthat was always yours.")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .multilineTextAlignment(.center)

                Spacer()

                Button(action: { navigationState.currentAnalysisState = .capturing }) {
                    Text("Find my colors")
                        .font(.custom("Inter", size: 17, relativeTo: .body))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "#C8A86E"))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: .init(
            get: { navigationState.currentAnalysisState == .capturing },
            set: { if !$0 { navigationState.currentAnalysisState = .notStarted } }
        )) {
            HowItWorksView()
        }
    }
}
