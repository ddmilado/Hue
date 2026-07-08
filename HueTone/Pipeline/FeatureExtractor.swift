import Foundation

struct ExtractedFeatures {
    let depth: Double
    let value: Double
    let chroma: Double
    let undertone: UndertoneType
    let contrast: Double
    let hueAngle: Double
}

class FeatureExtractor {

    func extract(from sampled: SampledColors) -> ExtractedFeatures {
        let depth = 1.0 - (sampled.skinLab.L / 100)
        let chroma = sqrt(sampled.skinLab.a * sampled.skinLab.a + sampled.skinLab.b * sampled.skinLab.b) / 100
        let hueAngle = atan2(sampled.skinLab.b, sampled.skinLab.a) * 180 / .pi

        let undertone: UndertoneType
        if hueAngle > 20 && hueAngle < 70 {
            undertone = .warm
        } else if hueAngle < -10 || hueAngle > 160 {
            undertone = .cool
        } else {
            undertone = .neutral
        }

        let contrast = abs(sampled.skinLab.L - sampled.hairLab.L) / 100
        let value = (sampled.skinLab.L + sampled.hairLab.L + sampled.eyeLab.L) / 300

        return ExtractedFeatures(
            depth: depth,
            value: value,
            chroma: chroma,
            undertone: undertone,
            contrast: contrast,
            hueAngle: hueAngle
        )
    }
}
