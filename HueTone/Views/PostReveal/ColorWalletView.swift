import SwiftUI

struct ColorWalletView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState
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
                    .accessibilityLabel("Your color wallet")

                if let result = navigationState.latestResult {
                    Text("\(result.season.rawValue) · \(paletteSwatches(for: result.season).count) colors")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color(hex: "#8B8290"))
                } else {
                    Text("Complete an analysis to see your palette")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color(hex: "#8B8290"))
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            CategoryPill(
                                category: cat,
                                isSelected: selectedCategory == cat,
                                themeManager: themeManager
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
                        let swatches = filteredSwatches()
                        if swatches.isEmpty {
                            Text("No colors in this category")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(Color(hex: "#8B8290"))
                                .padding(.top, 40)
                        } else {
                            ForEach(swatches, id: \.id) { swatch in
                                SwatchCard(swatch: swatch, size: 80)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }

                Button(action: sharePalette) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Palette")
                    }
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(themeManager.accentSafeColor)
                    .padding(.vertical, 12)
                }
                .padding(.bottom, 8)
                .accessibilityLabel("Share palette")
            }
        }
    }

    private func filteredSwatches() -> [PaletteSwatch] {
        guard let result = navigationState.latestResult else { return [] }
        let all = paletteSwatches(for: result.season)
        if let cat = selectedCategory {
            return all.filter { $0.category == cat }
        }
        return all
    }

    private func sharePalette() {
        guard let result = navigationState.latestResult else { return }
        let seasonName = result.season.rawValue
        let swatches = paletteSwatches(for: result.season)
        let hexList = swatches.map(\.hexValue).joined(separator: ", ")
        let text = "My \(seasonName) palette from Hue Tone: \(hexList)"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            root.present(av, animated: true)
        }
    }

    private func paletteSwatches(for season: Season) -> [PaletteSwatch] {
        let paletteMap: [Season: [(hex: String, name: String, category: SwatchCategory, lab: LabValue)]] = [
            .deepAutumn: [
                ("#4A3728", "Espresso", .brown, LabValue(L: 25, a: 3, b: 6)),
                ("#8B4513", "Saddle Brown", .brown, LabValue(L: 35, a: 10, b: 20)),
                ("#A0522D", "Sienna", .brown, LabValue(L: 40, a: 15, b: 25)),
                ("#CD853F", "Peru", .brown, LabValue(L: 55, a: 12, b: 30)),
                ("#D2691E", "Chocolate", .brown, LabValue(L: 50, a: 14, b: 28)),
                ("#6B4226", "Dark Brown", .brown, LabValue(L: 30, a: 5, b: 12)),
                ("#556B2F", "Dark Olive", .green, LabValue(L: 40, a: -8, b: 20)),
                ("#6B8E23", "Olive Drab", .green, LabValue(L: 50, a: -10, b: 25)),
                ("#4A7C59", "Fern Green", .green, LabValue(L: 45, a: -12, b: 18)),
                ("#8B5E3C", "Cinnamon", .brown, LabValue(L: 42, a: 12, b: 22)),
                ("#9C6B3E", "Camel", .neutral, LabValue(L: 50, a: 8, b: 20)),
                ("#B8860B", "Dark Goldenrod", .yellow, LabValue(L: 55, a: 5, b: 35)),
                ("#DAA520", "Goldenrod", .yellow, LabValue(L: 60, a: 5, b: 40)),
                ("#F5DEB3", "Wheat", .neutral, LabValue(L: 75, a: 2, b: 18)),
                ("#FFE4B5", "Moccasin", .neutral, LabValue(L: 78, a: 5, b: 20)),
                ("#DEB887", "Burlywood", .neutral, LabValue(L: 68, a: 8, b: 22)),
                ("#D2B48C", "Tan", .neutral, LabValue(L: 65, a: 5, b: 18)),
                ("#BC8F8F", "Rosy Brown", .brown, LabValue(L: 58, a: 10, b: 8)),
                ("#C0C0C0", "Silver", .metal, LabValue(L: 75, a: 0, b: 0)),
                ("#FFD700", "Gold", .metal, LabValue(L: 70, a: 5, b: 50)),
                ("#B76E79", "Rose Gold", .metal, LabValue(L: 55, a: 18, b: 8)),
                ("#71797E", "Gunmetal", .gray, LabValue(L: 45, a: -2, b: 2)),
                ("#36454F", "Charcoal", .gray, LabValue(L: 30, a: -2, b: 0)),
                ("#2F2F2F", "Dark Gray", .gray, LabValue(L: 20, a: 0, b: 0)),
                ("#1C1B1F", "Ink", .black, LabValue(L: 12, a: 0, b: 2)),
                ("#0A0A0A", "Black", .black, LabValue(L: 5, a: 0, b: 0)),
                ("#F5F5DC", "Beige", .white, LabValue(L: 85, a: 0, b: 8)),
                ("#FAEBD7", "Antique White", .white, LabValue(L: 88, a: 2, b: 10)),
                ("#F8F8FF", "Ghost White", .white, LabValue(L: 92, a: 0, b: -2)),
                ("#FFFAF0", "Floral White", .white, LabValue(L: 90, a: 2, b: 8)),
                ("#FFFFFF", "White", .white, LabValue(L: 100, a: 0, b: 0)),
                ("#8B7355", "Sandalwood", .brown, LabValue(L: 48, a: 6, b: 16)),
            ],
            .deepWinter: [
                ("#0A0A0A", "Black", .black, LabValue(L: 5, a: 0, b: 0)),
                ("#1C1B1F", "Ink", .black, LabValue(L: 12, a: 0, b: 2)),
                ("#2F2F2F", "Dark Gray", .gray, LabValue(L: 20, a: 0, b: 0)),
                ("#36454F", "Charcoal", .gray, LabValue(L: 30, a: -2, b: 0)),
                ("#4A0404", "Burgundy", .red, LabValue(L: 20, a: 15, b: 5)),
                ("#800020", "Deep Red", .red, LabValue(L: 30, a: 25, b: 10)),
                ("#702963", "Eggplant", .purple, LabValue(L: 28, a: 18, b: -8)),
                ("#191970", "Midnight Blue", .navy, LabValue(L: 18, a: 8, b: -18)),
                ("#1B3B6F", "Deep Navy", .navy, LabValue(L: 25, a: 5, b: -20)),
                ("#003153", "Prussian Blue", .navy, LabValue(L: 22, a: 2, b: -12)),
                ("#006400", "Deep Green", .green, LabValue(L: 30, a: -15, b: 12)),
                ("#0B6623", "Forest Green", .green, LabValue(L: 35, a: -18, b: 15)),
                ("#E6E6FA", "Lavender", .purple, LabValue(L: 78, a: 8, b: -8)),
                ("#C0C0C0", "Silver", .metal, LabValue(L: 75, a: 0, b: 0)),
                ("#FFFFFF", "White", .white, LabValue(L: 100, a: 0, b: 0)),
                ("#FFB6C1", "Light Pink", .pink, LabValue(L: 75, a: 15, b: 5)),
            ],
        ]

        let defaults: [(hex: String, name: String, category: SwatchCategory, lab: LabValue)] = [
            ("#8B4513", "Saddle Brown", .brown, LabValue(L: 35, a: 10, b: 20)),
            ("#D2691E", "Chocolate", .brown, LabValue(L: 50, a: 14, b: 28)),
            ("#CD853F", "Peru", .brown, LabValue(L: 55, a: 12, b: 30)),
            ("#C0C0C0", "Silver", .metal, LabValue(L: 75, a: 0, b: 0)),
            ("#FFD700", "Gold", .metal, LabValue(L: 70, a: 5, b: 50)),
            ("#FFFFFF", "White", .white, LabValue(L: 100, a: 0, b: 0)),
            ("#1C1B1F", "Ink", .black, LabValue(L: 12, a: 0, b: 2)),
            ("#36454F", "Charcoal", .gray, LabValue(L: 30, a: -2, b: 0)),
            ("#6B8E23", "Olive Drab", .green, LabValue(L: 50, a: -10, b: 25)),
            ("#DAA520", "Goldenrod", .yellow, LabValue(L: 60, a: 5, b: 40)),
        ]

        return (paletteMap[season] ?? defaults).map { item in
            PaletteSwatch(
                season: season,
                category: item.category,
                hexValue: item.hex,
                colorName: item.name,
                harmonyScore: 0.85,
                lab: item.lab
            )
        }
    }
}
