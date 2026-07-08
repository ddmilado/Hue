import Foundation

struct PaletteSwatch: Codable, Identifiable {
    let id: UUID
    let season: Season
    let category: SwatchCategory
    let hexValue: String
    let colorName: String
    let harmonyScore: Double
    let lab: LabValue

    var chroma: Double {
        sqrt(lab.a * lab.a + lab.b * lab.b)
    }

    init(id: UUID = UUID(), season: Season, category: SwatchCategory,
         hexValue: String, colorName: String = "", harmonyScore: Double = 1.0,
         lab: LabValue = LabValue()) {
        self.id = id
        self.season = season
        self.category = category
        self.hexValue = hexValue
        self.colorName = colorName
        self.harmonyScore = harmonyScore
        self.lab = lab
    }
}

enum SwatchCategory: String, Codable, CaseIterable {
    case metal
    case white
    case brown
    case black
    case gray
    case navy
    case red
    case pink
    case orange
    case yellow
    case green
    case teal
    case blue
    case purple
    case neutral
}
