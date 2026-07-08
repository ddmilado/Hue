import Foundation

class RuleBasedClassifier {

    func classify(features: ExtractedFeatures) -> SeasonResult {
        let depth = features.depth
        let chroma = features.chroma
        let undertone = features.undertone
        let contrast = features.contrast
        let value = features.value

        var primarySeason: Season
        var secondarySeason: Season?
        var confidence: Double

        if chroma >= 0.55 {
            confidence = 0.75 + chroma * 0.2
            if undertone == .warm {
                if contrast >= 0.45 {
                    primarySeason = .brightSpring
                } else if value >= 0.55 {
                    primarySeason = .lightSpring
                } else {
                    primarySeason = .trueSpring
                }
            } else {
                if contrast >= 0.50 {
                    primarySeason = .brightWinter
                } else if value >= 0.50 {
                    primarySeason = .trueWinter
                } else {
                    primarySeason = .deepWinter
                }
            }
        } else if chroma >= 0.30 {
            confidence = 0.65 + chroma * 0.25
            if undertone == .warm {
                if depth >= 0.55 {
                    primarySeason = .deepAutumn
                } else if value >= 0.55 {
                    primarySeason = .trueAutumn
                } else {
                    primarySeason = .softAutumn
                }
            } else {
                if depth >= 0.55 {
                    primarySeason = .deepSummer
                    secondarySeason = .deepWinter
                } else if value >= 0.55 {
                    primarySeason = .lightSummer
                } else {
                    primarySeason = .trueSummer
                }
            }
        } else {
            confidence = 0.50 + chroma * 0.4
            if undertone == .warm {
                primarySeason = .softAutumn
                secondarySeason = .softSpring
            } else {
                primarySeason = .softSummer
                secondarySeason = .softWinter
            }
        }

        confidence = min(0.99, max(0.3, confidence))

        let metricsId = UUID()
        return SeasonResult(
            colorMetricsId: metricsId,
            season: primarySeason,
            confidence: confidence,
            classificationMethod: .ruleBased,
            secondarySeason: secondarySeason
        )
    }
}
