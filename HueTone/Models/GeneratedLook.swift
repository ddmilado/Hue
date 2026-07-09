import Foundation

struct GeneratedLook: Codable, Identifiable {
    let id: UUID
    let garmentType: String
    let createdAt: Date
    var imageFilename: String?
    let seasonName: String

    init(id: UUID = UUID(), garmentType: String,
         createdAt: Date = Date(), imageFilename: String? = nil,
         seasonName: String = "") {
        self.id = id
        self.garmentType = garmentType
        self.createdAt = createdAt
        self.imageFilename = imageFilename
        self.seasonName = seasonName
    }
}
