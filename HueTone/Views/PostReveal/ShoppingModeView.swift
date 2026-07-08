import SwiftUI

struct ShoppingModeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            if navigationState.latestResult == nil {
                VStack(spacing: 24) {
                    Spacer()
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 64))
                        .foregroundColor(Color(hex: "#8B8290"))

                    Text("Shopping Mode")
                        .font(.custom("Fraunces", size: 28))
                        .foregroundColor(Color(hex: "#F7F2EC"))

                    Text("Point your camera at any garment to see\nif it matches your palette.")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(Color(hex: "#8B8290"))
                        .multilineTextAlignment(.center)

                    Text("Premium Feature")
                        .font(.custom("Inter", size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.accentSafeColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(themeManager.accentSafeColor.opacity(0.15))
                        .cornerRadius(8)

                    Button(action: {}) {
                        Text("Upgrade to Premium")
                            .font(.custom("Inter", size: 17, relativeTo: .body))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(themeManager.accentSafeColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)

                    Spacer()
                }
            } else {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "#2A2729"))
                            .aspectRatio(3/4, contentMode: .fit)

                        Image(systemName: "video.fill")
                            .font(.system(size: 48))
                            .foregroundColor(Color(hex: "#F7F2EC").opacity(0.3))
                    }
                    .padding()

                    HStack(spacing: 12) {
                        ForEach(["#8B4513", "#D2691E", "#CD853F", "#DAA520", "#6B8E23"], id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
