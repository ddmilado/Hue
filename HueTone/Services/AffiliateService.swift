import Foundation

class AffiliateService {
    static let shared = AffiliateService()

    let disclaimer = "We may earn a commission from purchases made through these links."

    func products(for swatch: PaletteSwatch) -> [AffiliateProduct] {
        mockProducts().filter { $0.hexValue == swatch.hexValue }
    }

    func products(for season: Season, category: SwatchCategory) -> [AffiliateProduct] {
        mockProducts()
    }

    private func mockProducts() -> [AffiliateProduct] {
        [
            AffiliateProduct(
                retailer: "Nordstrom",
                productURL: "https://nordstrom.com/p/1",
                category: .brown,
                hexValue: "#8B4513",
                price: "$195",
                title: "Wool Blazer"
            ),
            AffiliateProduct(
                retailer: "Nordstrom",
                productURL: "https://nordstrom.com/p/2",
                category: .brown,
                hexValue: "#D2691E",
                price: "$135",
                title: "Silk Blouse"
            ),
            AffiliateProduct(
                retailer: "Nordstrom",
                productURL: "https://nordstrom.com/p/3",
                category: .neutral,
                hexValue: "#CD853F",
                price: "$65",
                title: "Leather Belt"
            ),
            AffiliateProduct(
                retailer: "Nordstrom",
                productURL: "https://nordstrom.com/p/4",
                category: .yellow,
                hexValue: "#B8860B",
                price: "$245",
                title: "Tote Bag"
            ),
            AffiliateProduct(
                retailer: "Nordstrom",
                productURL: "https://nordstrom.com/p/5",
                category: .yellow,
                hexValue: "#DAA520",
                price: "$89",
                title: "Wool Scarf"
            ),
            AffiliateProduct(
                retailer: "Nordstrom",
                productURL: "https://nordstrom.com/p/6",
                category: .green,
                hexValue: "#6B8E23",
                price: "$345",
                title: "Leather Boots"
            ),
        ]
    }
}
