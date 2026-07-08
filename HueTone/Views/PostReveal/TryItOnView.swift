import SwiftUI

struct TryItOnView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState

    @State private var selectedGarment = "Blouse"
    @State private var showGenerationLimit = false

    let garments = ["Blouse", "Dress", "Coat", "Top", "Jacket", "Sweater"]
    let generationsRemaining = 3

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Try It On")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding(.top, 8)
                    .accessibilityLabel("Try it on")

                if generationsRemaining <= 0 && navigationState.latestResult == nil {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "sparkles.rectangle.stack")
                            .font(.system(size: 48))
                            .foregroundColor(Color(hex: "#8B8290"))
                        Text("You've used all your generations this month")
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(Color(hex: "#8B8290"))
                        Button(action: { showGenerationLimit = true }) {
                            Text("Upgrade to Premium")
                                .font(.custom("Inter", size: 17, relativeTo: .body))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .background(themeManager.accentSafeColor)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 40)
                        Spacer()
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(garments, id: \.self) { garment in
                                CategoryPill(
                                    category: SwatchCategory(rawValue: garment.lowercased()) ?? .neutral,
                                    isSelected: selectedGarment == garment,
                                    themeManager: themeManager
                                )
                                .overlay(Text(garment).padding(.horizontal, 8))
                                .onTapGesture { selectedGarment = garment }
                            }
                        }
                        .padding(.horizontal, 24)
                    }

                    Text("\(generationsRemaining) generations remaining this month")
                        .font(.custom("Inter", size: 12))
                        .foregroundColor(Color(hex: "#8B8290"))

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(0..<4, id: \.self) { _ in
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "#2A2729"))
                                    .aspectRatio(3/4, contentMode: .fit)
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(hex: "#F7F2EC").opacity(0.15))
                            }
                        }
                    }
                    .padding(.horizontal, 24)

                    Button(action: {}) {
                        Text("Generate Outfits")
                            .font(.custom("Inter", size: 17, relativeTo: .body))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(themeManager.accentSafeColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .accessibilityLabel("Generate outfits")
                }
            }

            if showGenerationLimit {
                UpgradePremiumView()
            }
        }
    }
}
