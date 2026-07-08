import SwiftUI

struct UpgradePremiumView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Image(systemName: "crown.fill")
                    .font(.system(size: 56))
                    .foregroundColor(themeManager.accentSafeColor)

                Text("Upgrade to Premium")
                    .font(.custom("Fraunces", size: 32))
                    .foregroundColor(Color(hex: "#F7F2EC"))

                VStack(alignment: .leading, spacing: 16) {
                    PremiumFeatureRow(icon: "infinity", text: "Unlimited Try It On generations")
                    PremiumFeatureRow(icon: "sparkles.rectangle.stack", text: "Pattern Studio access")
                    PremiumFeatureRow(icon: "camera.viewfinder", text: "Shopping Mode")
                    PremiumFeatureRow(icon: "star.fill", text: "Priority curated picks")
                }
                .padding(.horizontal, 32)

                Text("$4.99/month · Cancel anytime")
                    .font(.custom("Inter", size: 16, relativeTo: .body))
                    .foregroundColor(Color(hex: "#8B8290"))

                Button(action: {}) {
                    Text("Subscribe")
                        .font(.custom("Inter", size: 17, relativeTo: .body))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(themeManager.accentSafeColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)

                Button(action: { dismiss() }) {
                    Text("Maybe later")
                        .font(.custom("Inter", size: 15))
                        .foregroundColor(Color(hex: "#8B8290"))
                }

                Spacer()
            }
        }
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#C8A86E"))
                .frame(width: 24)
            Text(text)
                .font(.custom("Inter", size: 15))
                .foregroundColor(Color(hex: "#F7F2EC"))
        }
    }
}
