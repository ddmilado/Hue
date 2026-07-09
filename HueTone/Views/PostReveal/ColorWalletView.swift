import SwiftUI

struct ColorWalletView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var generationService = GenerationService.shared
    @State private var selectedCategory: SwatchCategory? = nil
    @State private var selectedSection = 0

    let categories: [SwatchCategory] = [
        .neutral, .metal, .white, .brown, .black, .gray,
        .navy, .red, .pink, .blue, .green, .purple
    ]

    let sectionLabels = ["Palette", "Saved Looks", "Tips"]

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 0) {
                header

                Picker("Section", selection: $selectedSection) {
                    ForEach(sectionLabels.indices, id: \.self) { i in
                        Text(sectionLabels[i]).tag(i)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)

                if selectedSection == 0 {
                    paletteSection
                } else if selectedSection == 1 {
                    savedLooksSection
                } else {
                    tipsSection
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 4) {
            Text("Color Wallet")
                .font(.custom("Fraunces", size: 28))
                .foregroundColor(Color(hex: "#F7F2EC"))
                .padding(.top, 12)

            if let result = navigationState.latestResult {
                Text(result.season.rawValue)
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(themeManager.accentSafeColor)
                    .fontWeight(.semibold)
            }
        }
        .padding(.bottom, 4)
    }

    // MARK: - Palette Section

    private var paletteSection: some View {
        VStack(spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { cat in
                        CategoryPill(
                            category: cat,
                            isSelected: selectedCategory == cat,
                            themeManager: themeManager
                        )
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.2)) {
                                selectedCategory = selectedCategory == cat ? nil : cat
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 72))], spacing: 12) {
                    let swatches = filteredSwatches()
                    if swatches.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "paintpalette")
                                .font(.title2)
                                .foregroundColor(Color(hex: "#8B8290"))
                            Text("No colors in this category")
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(Color(hex: "#8B8290"))
                        }
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity)
                    } else {
                        ForEach(swatches, id: \.id) { swatch in
                            SwatchCard(swatch: swatch, size: 72)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
            }

            shareButton
        }
    }

    private var shareButton: some View {
        Button(action: sharePalette) {
            HStack(spacing: 6) {
                Image(systemName: "square.and.arrow.up")
                Text("Share Palette")
            }
            .font(.custom("Inter", size: 14))
            .foregroundColor(themeManager.accentSafeColor)
            .padding(.vertical, 10)
        }
        .padding(.bottom, 4)
        .accessibilityLabel("Share palette")
    }

    // MARK: - Saved Looks Section

    private var savedLooksSection: some View {
        Group {
            if generationService.savedLooks.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "sparkles.rectangle.stack")
                        .font(.system(size: 48))
                        .foregroundColor(Color(hex: "#8B8290").opacity(0.5))
                    Text("No saved looks yet")
                        .font(.custom("Fraunces", size: 20))
                        .foregroundColor(Color(hex: "#F7F2EC"))
                    Text("Go to Try It On to generate outfits\nin your season's colors")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color(hex: "#8B8290"))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(generationService.savedLooks) { look in
                            ZStack(alignment: .topTrailing) {
                                if let img = generationService.image(for: look) {
                                    Image(uiImage: img)
                                        .resizable()
                                        .aspectRatio(3/4, contentMode: .fit)
                                        .cornerRadius(12)
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex: "#2A2729"))
                                        .aspectRatio(3/4, contentMode: .fit)
                                }

                                Button(action: { generationService.deleteLook(look) }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(Color(hex: "#8B8290"))
                                        .background(Circle().fill(Color.black.opacity(0.5)))
                                }
                                .padding(6)
                                .accessibilityLabel("Delete look")
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                }
            }
        }
    }

    // MARK: - Tips Section

    private var tipsSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let season = navigationState.latestResult?.season {
                    seasonTips(for: season)
                } else {
                    Text("Complete an analysis to see personalized tips")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color(hex: "#8B8290"))
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(24)
        }
    }

    private func seasonTips(for season: Season) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            tipCard(
                icon: "star.fill",
                title: "Your Best Neutrals",
                body: seasonNeutralTip(for: season),
                color: themeManager.accentSafeColor
            )
            tipCard(
                icon: "paintbrush.fill",
                title: "Accent Colors",
                body: seasonAccentTip(for: season),
                color: themeManager.accentSafeColor
            )
            tipCard(
                icon: "exclamationmark.triangle.fill",
                title: "Colors to Avoid",
                body: seasonAvoidTip(for: season),
                color: .orange
            )
            tipCard(
                icon: "cart.fill",
                title: "Shopping Strategy",
                body: seasonShoppingTip(for: season),
                color: themeManager.accentSafeColor
            )
        }
    }

    private func tipCard(icon: String, title: String, body text: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Inter", size: 15))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#F7F2EC"))
                Text(text)
                    .font(.custom("Inter", size: 13))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .lineSpacing(3)
            }
        }
        .padding(14)
        .background(Color(hex: "#2A2729"))
        .cornerRadius(12)
    }

    // MARK: - Season Tips

    private func seasonNeutralTip(for season: Season) -> String {
        switch season {
        case .deepAutumn, .trueAutumn, .softAutumn:
            return "Camel, cream, olive, and warm grays. Avoid icy whites and blue-toned grays."
        case .deepWinter, .trueWinter, .brightWinter:
            return "Crisp white, charcoal, true gray, and navy. Avoid warm browns and beiges."
        case .lightSpring, .trueSpring, .brightSpring:
            return "Ivory, cream, warm gray, and camel. Avoid stark black and white."
        case .lightSummer, .trueSummer, .softSummer:
            return "Powder blue, soft gray, heather, and rose beige. Avoid warm oranges."
        default:
            return "Stick to your season's core palette for neutrals."
        }
    }

    private func seasonAccentTip(for season: Season) -> String {
        switch season {
        case .deepAutumn, .trueAutumn:
            return "Olive green, rust, mustard, and burgundy make powerful accent pieces."
        case .deepWinter, .trueWinter:
            return "Ruby red, emerald, sapphire blue, and fuchsia for striking accents."
        case .brightSpring:
            return "Hot pink, turquoise, coral, and lime green for playful pops of color."
        case .lightSpring, .trueSpring:
            return "Peach, sky blue, mint, and lavender for soft, feminine accents."
        case .lightSummer, .trueSummer:
            return "Lavender, rose pink, powder blue, and seafoam for romantic accents."
        case .softSummer, .softAutumn:
            return "Dusty rose, sage, mauve, and heather gray for subtle, sophisticated accents."
        case .brightWinter:
            return "Electric blue, hot pink, emerald, and lemon yellow for bold statements."
        default:
            return "Use your palette's brightest colors as accents."
        }
    }

    private func seasonAvoidTip(for season: Season) -> String {
        switch season {
        case .deepAutumn, .trueAutumn, .softAutumn:
            return "Icy pastels, blue-based pinks, and cool grays will wash you out."
        case .deepWinter, .trueWinter, .brightWinter:
            return "Warm oranges, yellow-greens, and muddied browns clash with your cool undertones."
        case .lightSpring, .trueSpring, .brightSpring:
            return "Deep, dark colors and stark black will overpower your lightness."
        case .lightSummer, .trueSummer, .softSummer:
            return "Neon brights and warm oranges disrupt your delicate, cool palette."
        default:
            return "Avoid colors from opposite season families."
        }
    }

    private func seasonShoppingTip(for season: Season) -> String {
        switch season {
        case .deepAutumn:
            return "Look for rich textures: suede, leather, wool in rust, olive, and deep brown."
        case .deepWinter:
            return "Invest in a great black blazer, white blouse, and ruby accessories."
        case .trueSpring:
            return "Shop for warm-weather fabrics in coral, gold, and sky blue."
        case .trueSummer:
            return "Build around soft neutrals: heather gray, lavender, and powder blue."
        case .brightSpring:
            return "Go for statement pieces in hot pink, turquoise, and lime."
        case .brightWinter:
            return "High contrast is your friend: black + white + one bright color."
        case .softAutumn:
            return "Your best buys: sage green sweaters, tan boots, dusty rose tops."
        case .trueAutumn:
            return "Mustard yellow, olive green, and camel are your power colors."
        case .lightSpring:
            return "Pastel blazers, light wash denim, and gold jewelry suit you best."
        case .lightSummer:
            return "Rose gold, lavender knits, and powder blue dresses are your staples."
        case .softSummer:
            return "Mauve, heather gray, and dusty blue create your best looks."
        case .softWinter:
            return "Charcoal, plum, and midnight blue with silver accessories."
        default:
            return "Build your wardrobe around your season's core palette."
        }
    }

    // MARK: - Palette Data

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
        let paletteMap: [Season: [(String, String, SwatchCategory, LabValue)]] = [
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

        let defaults: [(String, String, SwatchCategory, LabValue)] = [
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
                category: item.2,
                hexValue: item.0,
                colorName: item.1,
                harmonyScore: 0.85,
                lab: item.3
            )
        }
    }
}
