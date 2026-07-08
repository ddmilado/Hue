import Foundation

struct LabValue: Codable {
    var L: Double
    var a: Double
    var b: Double

    init(L: Double = 0, a: Double = 0, b: Double = 0) {
        self.L = L
        self.a = a
        self.b = b
    }
}

struct ColorMetrics: Codable, Identifiable {
    let id: UUID
    let photoSetId: UUID
    var skinLab: LabValue
    var hairLab: LabValue
    var eyeLab: LabValue
    var depthScore: Double
    var valueScore: Double
    var chromaScore: Double
    var contrastScore: Double
    var undertone: UndertoneType

    init(id: UUID = UUID(), photoSetId: UUID,
         skinLab: LabValue = LabValue(), hairLab: LabValue = LabValue(), eyeLab: LabValue = LabValue(),
         depthScore: Double = 0, valueScore: Double = 0, chromaScore: Double = 0,
         contrastScore: Double = 0, undertone: UndertoneType = .neutral) {
        self.id = id
        self.photoSetId = photoSetId
        self.skinLab = skinLab
        self.hairLab = hairLab
        self.eyeLab = eyeLab
        self.depthScore = depthScore
        self.valueScore = valueScore
        self.chromaScore = chromaScore
        self.contrastScore = contrastScore
        self.undertone = undertone
    }
}

enum UndertoneType: String, Codable, CaseIterable {
    case warm
    case cool
    case neutral
}
