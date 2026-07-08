import Foundation

struct GeneratedLook: Codable, Identifiable {
    let id: UUID
    let userId: UUID
    let sourcePhotoId: UUID
    let garmentType: String
    let targetSwatchId: UUID
    let modelUsed: ImageModel
    let generatedImageURL: String
    let createdAt: Date

    init(id: UUID = UUID(), userId: UUID, sourcePhotoId: UUID,
         garmentType: String, targetSwatchId: UUID,
         modelUsed: ImageModel = .nanoBanana2,
         generatedImageURL: String = "", createdAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.sourcePhotoId = sourcePhotoId
        self.garmentType = garmentType
        self.targetSwatchId = targetSwatchId
        self.modelUsed = modelUsed
        self.generatedImageURL = generatedImageURL
        self.createdAt = createdAt
    }
}

enum ImageModel: String, Codable {
    case nanoBanana2 = "gemini-2.0-flash-image"
    case nanoBananaPro = "gemini-2.0-pro-image"
}
