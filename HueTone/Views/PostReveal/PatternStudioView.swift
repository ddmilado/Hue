import SwiftUI

struct PatternStudioView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "sparkles")
                    .font(.system(size: 64))
                    .foregroundColor(themeManager.accentSafeColor)

                Text("Pattern Studio")
                    .font(.custom("Fraunces", size: 32))
                    .foregroundColor(Color(hex: "#F7F2EC"))

                Text("Recolor any garment or print into\nyour personal palette.")
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
        }
    }
}
