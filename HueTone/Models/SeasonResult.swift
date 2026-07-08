import Foundation

struct SeasonResult: Codable, Identifiable {
    let id: UUID
    let colorMetricsId: UUID
    let season: Season
    let confidence: Double
    let classificationMethod: ClassificationMethod
    let secondarySeason: Season?

    init(id: UUID = UUID(), colorMetricsId: UUID, season: Season,
         confidence: Double, classificationMethod: ClassificationMethod = .ruleBased,
         secondarySeason: Season? = nil) {
        self.id = id
        self.colorMetricsId = colorMetricsId
        self.season = season
        self.confidence = confidence
        self.classificationMethod = classificationMethod
        self.secondarySeason = secondarySeason
    }
}

enum Season: String, Codable, CaseIterable {
    case lightSpring = "Light Spring"
    case trueSpring = "True Spring"
    case brightSpring = "Bright Spring"
    case lightSummer = "Light Summer"
    case trueSummer = "True Summer"
    case softSummer = "Soft Summer"
    case softAutumn = "Soft Autumn"
    case trueAutumn = "True Autumn"
    case deepAutumn = "Deep Autumn"
    case brightWinter = "Bright Winter"
    case trueWinter = "True Winter"
    case deepWinter = "Deep Winter"

    case softSpring = "Soft Spring"
    case lightAutumn = "Light Autumn"
    case deepSummer = "Deep Summer"
    case softWinter = "Soft Winter"
}

enum ClassificationMethod: String, Codable {
    case ruleBased
    case mlV2
}
