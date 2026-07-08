import SwiftUI

struct ColorWalletView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedCategory: SwatchCategory? = nil

    let categories: [SwatchCategory] = [.neutral, .metal, .white, .brown, .black, .gray, .navy, .red, .pink, .blue, .green, .purple]

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Your Color Wallet")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding(.top, 8)

                Text("Deep Autumn · 32 colors")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color(hex: "#8B8290"))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            CategoryPill(
                                category: cat,
                                isSelected: selectedCategory == cat
                            )
                            .onTapGesture {
                                selectedCategory = selectedCategory == cat ? nil : cat
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 16) {
                        ForEach(demoSwatches(), id: \.id) { swatch in
                            SwatchCard(swatch: swatch, size: 80)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }

                Button(action: {}) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Palette")
                    }
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(themeManager.accentSafeColor)
                    .padding(.vertical, 12)
                }
                .padding(.bottom, 8)
            }
        }
    }

    private func demoSwatches() -> [PaletteSwatch] {
        let hexes = ["#8B4513", "#D2691E", "#CD853F", "#B8860B", "#DAA520",
                     "#6B8E23", "#556B2F", "#A0522D", "#F5DEB3", "#FFE4B5",
                     "#DEB887", "#D2B48C", "#BC8F8F", "#A0522D", "#8B7355",
                     "#6B4226", "#C0C0C0", "#FFD700", "#B76E79", "#71797E",
                     "#F5F5DC", "#FAEBD7", "#F8F8FF", "#FFFAF0", "#FFFFFF",
                     "#36454F", "#2F2F2F", "#1C1B1F", "#0A0A0A", "#000000",
                     "#4A7C59", "#8B5E3C", "#9C6B3E"]
        return hexes.enumerated().map { i, hex in
            PaletteSwatch(
                season: .deepAutumn,
                category: categories[i % categories.count],
                hexValue: hex,
                colorName: "Color \(i + 1)",
                harmonyScore: 0.8,
                lab: LabValue(L: 50, a: 5, b: 10)
            )
        }
    }
}
