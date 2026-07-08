import Foundation

struct AffiliateProduct: Codable, Identifiable {
    let id: UUID
    let retailer: String
    let productURL: String
    let category: SwatchCategory
    let hexValue: String
    let matchedSwatchId: UUID?
    let seasonTags: [Season]
    let commissionType: CommissionType
    let price: String
    let title: String
    let thumbnailURL: String

    init(id: UUID = UUID(), retailer: String, productURL: String,
         category: SwatchCategory, hexValue: String,
         matchedSwatchId: UUID? = nil, seasonTags: [Season] = [],
         commissionType: CommissionType = .cpc,
         price: String = "", title: String = "", thumbnailURL: String = "") {
        self.id = id
        self.retailer = retailer
        self.productURL = productURL
        self.category = category
        self.hexValue = hexValue
        self.matchedSwatchId = matchedSwatchId
        self.seasonTags = seasonTags
        self.commissionType = commissionType
        self.price = price
        self.title = title
        self.thumbnailURL = thumbnailURL
    }
}

enum CommissionType: String, Codable {
    case cpc
    case cpa
}
