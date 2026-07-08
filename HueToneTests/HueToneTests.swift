import XCTest
@testable import HueTone

final class HueToneTests: XCTestCase {
    func testColorScience() {
        let lab = ColorScience.srgbToLab(r: 0.5, g: 0.3, b: 0.2)
        XCTAssertGreaterThan(lab.L, 0)
    }

    func testDeltaE() {
        let lab1 = LabValue(L: 50, a: 10, b: 15)
        let lab2 = LabValue(L: 55, a: 12, b: 18)
        let dE = ColorScience.deltaE2000(lab1: lab1, lab2: lab2)
        XCTAssertGreaterThan(dE, 0)
    }

    func testClassifier() {
        let classifier = RuleBasedClassifier()
        let features = ExtractedFeatures(
            depth: 0.6, value: 0.55, chroma: 0.45,
            undertone: .warm, contrast: 0.5, hueAngle: 45
        )
        let result = classifier.classify(features: features)
        XCTAssertFalse(result.season.rawValue.isEmpty)
        XCTAssertGreaterThan(result.confidence, 0)
    }

    func testThemeManager() {
        let manager = ThemeManager()
        let swatches = [
            PaletteSwatch(season: .deepAutumn, category: .neutral, hexValue: "#8B4513",
                         harmonyScore: 0.9, lab: LabValue(L: 40, a: 12, b: 20)),
            PaletteSwatch(season: .deepAutumn, category: .neutral, hexValue: "#D2691E",
                         harmonyScore: 0.85, lab: LabValue(L: 55, a: 15, b: 30))
        ]
        manager.computeAccent(from: swatches)
        XCTAssertFalse(manager.signatureAccent.isEmpty)
    }

    func testHarmonyScore() {
        let userLab = LabValue(L: 50, a: 10, b: 15)
        let swatchLab = LabValue(L: 55, a: 12, b: 18)
        let score = ColorScience.harmonyScore(userLab: userLab, swatchLab: swatchLab, userContrast: 0.5)
        XCTAssertGreaterThan(score, 0)
        XCTAssertLessThanOrEqual(score, 1)
    }
}
