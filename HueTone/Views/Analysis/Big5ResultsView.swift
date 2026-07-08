import SwiftUI

struct Big5ResultsView: View {
    @State private var showReveal = false
    @EnvironmentObject var themeManager: ThemeManager

    let depth: Double = 0.6
    let value: Double = 0.55
    let chroma: Double = 0.45
    let undertone: Double = 0.7
    let contrast: Double = 0.5

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Text("Your Big 5")
                    .font(.custom("Fraunces", size: 32))
                    .foregroundColor(Color(hex: "#F7F2EC"))

                Text("The dimensions that define your season")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color(hex: "#8B8290"))

                VStack(spacing: 16) {
                    Big5Row(label: "Depth", value: depth, leftLabel: "Light", rightLabel: "Deep",
                           description: "How light or dark your overall coloring is")
                    Big5Row(label: "Value", value: value, leftLabel: "Light", rightLabel: "Dark",
                           description: "The lightness of your skin, hair, and eyes combined")
                    Big5Row(label: "Chroma", value: chroma, leftLabel: "Soft", rightLabel: "Bright",
                           description: "How clear or muted your natural colors are")
                    Big5Row(label: "Undertone", value: undertone, leftLabel: "Cool", rightLabel: "Warm",
                           description: "The underlying hue temperature of your skin")
                    Big5Row(label: "Contrast", value: contrast, leftLabel: "Low", rightLabel: "High",
                           description: "The difference between your skin, hair, and eye values")
                }
                .padding(.horizontal, 24)

                Spacer()

                Button(action: { showReveal = true }) {
                    Text("See My Season")
                        .font(.custom("Inter", size: 17, relativeTo: .body))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(themeManager.accentSafeColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showReveal) {
            SeasonRevealView()
        }
    }
}

struct Big5Row: View {
    let label: String
    let value: Double
    let leftLabel: String
    let rightLabel: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.custom("Inter", size: 14, relativeTo: .body))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#F7F2EC"))
                Spacer()
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 6)

                    Capsule()
                        .fill(Color(hex: "#C8A86E"))
                        .frame(width: geo.size.width * value, height: 6)
                }
            }
            .frame(height: 6)

            HStack {
                Text(leftLabel)
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#8B8290"))
                Spacer()
                Text(rightLabel)
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#8B8290"))
            }

            Text(description)
                .font(.caption2)
                .foregroundColor(Color(hex: "#8B8290").opacity(0.7))
        }
    }
}
