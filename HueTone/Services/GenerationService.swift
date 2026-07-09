import Foundation
import SwiftUI

@MainActor
final class GenerationService: ObservableObject {
    static let shared = GenerationService()

    @Published var savedLooks: [GeneratedLook] = []
    @Published var isGenerating = false
    @Published var generationError: String?

    private let storage = StorageService.shared
    private let looksKey = "saved_looks"

    private init() {
        loadSaved()
    }

    func generateOutfit(userPhoto: UIImage, garmentType: String, season: Season) async {
        isGenerating = true
        generationError = nil
        defer { isGenerating = false }

        do {
            // Simulate generation delay
            try await Task.sleep(nanoseconds: 2_500_000_000)

            // Create a placeholder generated image using season colors
            let palette = seasonPalette(for: season)
            let generatedImage = renderPlaceholderOutfit(
                userPhoto: userPhoto,
                season: season,
                colors: palette.map { $0.hex }
            )

            // Save image to documents
            let filename = "look_\(UUID().uuidString).jpg"
            try saveImage(generatedImage, filename: filename)

            // Create look record
            let look = GeneratedLook(
                garmentType: garmentType,
                imageFilename: filename,
                seasonName: season.rawValue
            )
            savedLooks.insert(look, at: 0)
            persist()
        } catch {
            generationError = "Generation failed. Try again."
        }
    }

    func deleteLook(_ look: GeneratedLook) {
        if let filename = look.imageFilename {
            deleteImage(filename)
        }
        savedLooks.removeAll { $0.id == look.id }
        persist()
    }

    func image(for look: GeneratedLook) -> UIImage? {
        guard let filename = look.imageFilename else { return nil }
        return loadImage(filename)
    }

    // MARK: - Persistence

    private func loadSaved() {
        savedLooks = (try? storage.load([GeneratedLook].self, for: looksKey)) ?? []
    }

    private func persist() {
        try? storage.save(savedLooks, for: looksKey)
    }

    // MARK: - Image I/O

    private func saveImage(_ image: UIImage, filename: String) throws {
        let dir = try imageDirectory()
        let url = dir.appendingPathComponent(filename)
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw GenerationError.imageSaveFailed
        }
        try data.write(to: url)
    }

    private func loadImage(_ filename: String) -> UIImage? {
        guard let dir = try? imageDirectory() else { return nil }
        let url = dir.appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    private func deleteImage(_ filename: String) {
        guard let dir = try? imageDirectory() else { return }
        let url = dir.appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
    }

    private func imageDirectory() throws -> URL {
        let docs = try FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask,
            appropriateFor: nil, create: true
        )
        let dir = docs.appendingPathComponent("generated_looks", isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    // MARK: - Demo rendering

    private func renderPlaceholderOutfit(userPhoto: UIImage, season: Season, colors: [String]) -> UIImage {
        let size = CGSize(width: 300, height: 400)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { ctx in
            // Background
            UIColor(hex: "#1C1B1F").setFill()
            ctx.fill(CGRect(origin: .zero, size: size))

            // Draw season name
            let seasonText = season.rawValue as NSString
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
            seasonText.draw(at: CGPoint(x: 16, y: 16), withAttributes: attrs)

            // Draw color swatches as outfit preview
            let swatchSize = CGSize(width: 40, height: 60)
            let startX = (size.width - CGFloat(min(colors.count, 5)) * (swatchSize.width + 8) + 8) / 2
            for (i, hex) in colors.prefix(5).enumerated() {
                let rect = CGRect(
                    x: startX + CGFloat(i) * (swatchSize.width + 8),
                    y: size.height / 2 - swatchSize.height / 2,
                    width: swatchSize.width,
                    height: swatchSize.height
                )
                let path = UIBezierPath(roundedRect: rect, cornerRadius: 8)
                UIColor(hex: hex).setFill()
                path.fill()
            }

            // Garment label
            let label = "Generated for \(season.rawValue)" as NSString
            label.draw(at: CGPoint(x: 16, y: size.height - 40), withAttributes: [
                .font: UIFont.systemFont(ofSize: 11),
                .foregroundColor: UIColor.gray
            ])
        }
    }

    private func seasonPalette(for season: Season) -> [(hex: String, name: String)] {
        let palettes: [Season: [(String, String)]] = [
            .deepAutumn: [("#4A3728", "Espresso"), ("#8B4513", "Saddle"), ("#CD853F", "Peru"),
                          ("#DAA520", "Gold"), ("#6B8E23", "Olive"), ("#8B5E3C", "Cinnamon")],
            .deepWinter: [("#0A0A0A", "Black"), ("#4A0404", "Burgundy"), ("#191970", "Navy"),
                          ("#702963", "Eggplant"), ("#FFFFFF", "White"), ("#C0C0C0", "Silver")],
            .trueSpring: [("#FF6B6B", "Coral"), ("#FFD700", "Gold"), ("#98FB98", "Mint"),
                          ("#87CEEB", "Sky"), ("#FFB347", "Peach"), ("#E6E6FA", "Lavender")],
            .trueSummer: [("#B0C4DE", "Steel"), ("#E6E6FA", "Lavender"), ("#F5DEB3", "Wheat"),
                          ("#98D8C8", "Sea"), ("#FFB6C1", "Pink"), ("#D8BFD8", "Thistle")],
            .brightSpring: [("#FF1493", "Hot Pink"), ("#FFD700", "Gold"), ("#00CED1", "Turquoise"),
                            ("#32CD32", "Lime"), ("#FF6347", "Tomato"), ("#9370DB", "Orchid")],
            .brightWinter: [("#FF0000", "Red"), ("#000000", "Black"), ("#FFFFFF", "White"),
                            ("#1E90FF", "Blue"), ("#FF1493", "Pink"), ("#C0C0C0", "Silver")],
            .softAutumn: [("#BC8F8F", "Rosy"), ("#D2B48C", "Tan"), ("#8FBC8F", "Sage"),
                          ("#BDB76B", "Khaki"), ("#DEB887", "Burly"), ("#A0522D", "Sienna")],
            .trueAutumn: [("#8B4513", "Saddle"), ("#D2691E", "Choco"), ("#CD853F", "Peru"),
                          ("#B8860B", "Gold"), ("#6B8E23", "Olive"), ("#8B5E3C", "Cinna")],
            .lightSpring: [("#FFE4B5", "Moccasin"), ("#FFB6C1", "Pink"), ("#98FB98", "Mint"),
                           ("#FFD700", "Gold"), ("#87CEEB", "Sky"), ("#FFA07A", "Salmon")],
            .lightSummer: [("#E6E6FA", "Lavender"), ("#F5DEB3", "Wheat"), ("#B0E0E6", "Powder"),
                           ("#FFB6C1", "Pink"), ("#D8BFD8", "Thistle"), ("#98D8C8", "Sea")],
            .softSummer: [("#B0C4DE", "Steel"), ("#BC8F8F", "Rosy"), ("#8FBC8F", "Sage"),
                          ("#D2B48C", "Tan"), ("#BDB76B", "Khaki"), ("#C0C0C0", "Silver")],
        ]
        return palettes[season] ?? [("#8B4513", "Brown"), ("#C0C0C0", "Silver"), ("#FFFFFF", "White")]
    }
}

enum GenerationError: LocalizedError {
    case imageSaveFailed
    var errorDescription: String? { "Failed to save generated image" }
}

private extension UIColor {
    convenience init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let h = Int(s, radix: 16) ?? 0
        self.init(red: CGFloat((h >> 16) & 0xFF) / 255,
                  green: CGFloat((h >> 8) & 0xFF) / 255,
                  blue: CGFloat(h & 0xFF) / 255, alpha: 1)
    }
}
