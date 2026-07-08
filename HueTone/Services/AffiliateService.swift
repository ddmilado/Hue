import Foundation

class AffiliateService {
    static let shared = AffiliateService()

    private let disclaimer = "We may earn a commission from purchases made through these links."

    func products(for swatch: PaletteSwatch) -> [AffiliateProduct] {
        []
    }

    func products(for season: Season, category: SwatchCategory) -> [AffiliateProduct] {
        []
    }
}
