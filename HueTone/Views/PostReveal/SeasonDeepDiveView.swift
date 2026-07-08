import SwiftUI

struct SeasonDeepDiveView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    let season = navigationState.latestResult?.season ?? .deepAutumn

                    Text(season.rawValue)
                        .font(.custom("Fraunces", size: 34))
                        .foregroundColor(Color(hex: "#F7F2EC"))
                        .padding(.top, 60)
                        .accessibilityLabel("Season: \(season.rawValue)")

                    Text(SeasonTaxonomy.description(for: season))
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(Color(hex: "#8B8290"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Characteristics")
                            .font(.custom("Fraunces", size: 22))
                            .foregroundColor(Color(hex: "#F7F2EC"))

                        ForEach(traits(for: season), id: \.self) { trait in
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(themeManager.accentSafeColor)
                                    .frame(width: 6, height: 6)
                                Text(trait)
                                    .font(.custom("Inter", size: 15))
                                    .foregroundColor(Color(hex: "#F7F2EC"))
                            }
                        }
                    }
                    .padding(.horizontal, 32)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Best Colors")
                            .font(.custom("Fraunces", size: 22))
                            .foregroundColor(Color(hex: "#F7F2EC"))

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                            ForEach(seasonColors(for: season), id: \.self) { hex in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: hex))
                                    .frame(height: 60)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 32)

                    Button(action: shareResult) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Your Result")
                        }
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(themeManager.accentSafeColor)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(themeManager.accentSafeColor.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                    .accessibilityLabel("Share your result")
                }
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding()
            }
        }
    }

    private func traits(for season: Season) -> [String] {
        switch season {
        case .deepAutumn, .trueAutumn, .softAutumn:
            return ["Warm undertone", "Medium-deep depth", "Rich, earthy chroma",
                    "Warm contrast", "Golden/honey tones"]
        case .deepWinter, .trueWinter, .brightWinter:
            return ["Cool undertone", "High contrast", "Clear, icy chroma",
                    "Blue/cool tones", "Stark depth"]
        case .lightSpring, .trueSpring, .brightSpring:
            return ["Warm undertone", "Light value", "Clear, bright chroma",
                    "Warm contrast", "Golden tones"]
        case .lightSummer, .trueSummer, .softSummer:
            return ["Cool undertone", "Light-medium value", "Soft, muted chroma",
                    "Cool contrast", "Rose/blue tones"]
        case .softSpring, .lightAutumn, .deepSummer, .softWinter:
            return ["Neutral undertone", "Balanced value", "Mixed chroma",
                    "Versatile contrast", "Blended tones"]
        }
    }

    private func seasonColors(for season: Season) -> [String] {
        switch season {
        case .deepAutumn, .trueAutumn, .softAutumn:
            return ["#8B4513", "#D2691E", "#CD853F", "#B8860B",
                    "#DAA520", "#6B8E23", "#556B2F", "#A0522D"]
        case .deepWinter, .trueWinter, .brightWinter:
            return ["#0A0A0A", "#191970", "#800020", "#006400",
                    "#E6E6FA", "#FFFFFF", "#FFB6C1", "#C0C0C0"]
        case .lightSpring, .trueSpring, .brightSpring:
            return ["#FFD700", "#FFA07A", "#FF69B4", "#98FB98",
                    "#87CEEB", "#FFFACD", "#FFB6C1", "#E0FFFF"]
        case .lightSummer, .trueSummer, .softSummer:
            return ["#B0C4DE", "#D8BFD8", "#BDB76B", "#BC8F8F",
                    "#87CEEB", "#F5F5DC", "#E6E6FA", "#C0C0C0"]
        default:
            return ["#8B4513", "#D2691E", "#CD853F", "#B8860B",
                    "#DAA520", "#6B8E23", "#556B2F", "#A0522D"]
        }
    }

    private func shareResult() {
        guard let season = navigationState.latestResult?.season else { return }
        let text = "I'm a \(season.rawValue) according to Hue Tone! 🎨"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            root.present(av, animated: true)
        }
    }
}
