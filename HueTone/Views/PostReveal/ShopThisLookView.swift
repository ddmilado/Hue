import SwiftUI

struct ShopThisLookView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Shop This Look")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding(.top, 8)

                Text("We may earn a commission from purchases made through these links.")
                    .font(.custom("Inter", size: 11))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(0..<6, id: \.self) { i in
                            ProductCard(
                                hex: ["#8B4513", "#D2691E", "#CD853F", "#B8860B", "#DAA520", "#6B8E23"][i],
                                title: ["Wool Blazer", "Silk Blouse", "Leather Belt", "Tote Bag", "Scarf", "Boots"][i],
                                retailer: "Nordstrom",
                                price: "$89–$245"
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}

struct ProductCard: View {
    let hex: String
    let title: String
    let retailer: String
    let price: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: hex))
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    VStack {
                        Spacer()
                        Text("Shop →")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(4)
                            .padding(8)
                    }
                )

            Text(title)
                .font(.custom("Inter", size: 14, relativeTo: .body))
                .foregroundColor(Color(hex: "#F7F2EC"))
                .lineLimit(1)

            Text(retailer)
                .font(.caption2)
                .foregroundColor(Color(hex: "#8B8290"))

            Text(price)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "#F7F2EC"))
        }
    }
}
