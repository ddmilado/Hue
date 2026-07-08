import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isPreReveal: Bool = true

    @Published var signatureAccent: String = "#C8A86E"
    @Published var signatureAccentSafe: String = "#C8A86E"

    var accentColor: Color {
        Color(hex: isPreReveal ? "#C8A86E" : signatureAccent)
    }

    var accentSafeColor: Color {
        Color(hex: isPreReveal ? "#C8A86E" : signatureAccentSafe)
    }

    func computeAccent(from palette: [PaletteSwatch]) {
        let filtered = palette.filter { swatch in
            let lab = swatch.lab
            return lab.L >= 35 && lab.L <= 65
        }

        guard let best = filtered.max(by: { $0.chroma < $1.chroma }) ?? palette.max(by: { $0.chroma < $1.chroma }) else {
            return
        }

        signatureAccent = best.hexValue

        let inkContrast = relativeLuminance(hex: "#1C1B1F")
        let porcelainContrast = relativeLuminance(hex: "#F7F2EC")
        let accentLuminance = relativeLuminance(hex: best.hexValue)

        let contrastWithInk = abs(inkContrast - accentLuminance)
        let contrastWithPorcelain = abs(porcelainContrast - accentLuminance)

        if contrastWithInk < 0.175 || contrastWithPorcelain < 0.175 {
            let lab = best.lab
            let adjustedL = max(35, min(65, lab.L > 50 ? lab.L + 15 : lab.L - 15))
            let adjusted = labToHex(L: adjustedL, a: lab.a, b: lab.b)
            signatureAccentSafe = adjusted
        } else {
            signatureAccentSafe = best.hexValue
        }
    }

    private func relativeLuminance(hex: String) -> Double {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        let linearize = { (c: Double) -> Double in
            c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * linearize(r) + 0.7152 * linearize(g) + 0.0722 * linearize(b)
    }

    private func labToHex(L: Double, a: Double, b: Double) -> String {
        let fy = (L + 16) / 116
        let fx = a / 500 + fy
        let fz = fy - b / 200

        let x = 95.047 * (fx > 0.206897 ? fx * fx * fx : (fx - 16.0 / 116) / 7.787)
        let y = 100.0 * (fy > 0.206897 ? fy * fy * fy : (fy - 16.0 / 116) / 7.787)
        let z = 108.883 * (fz > 0.206897 ? fz * fz * fz : (fz - 16.0 / 116) / 7.787)

        let xr = x / 100, yr = y / 100, zr = z / 100
        let r = xr * 3.2406 + yr * -1.5372 + zr * -0.4986
        let g = xr * -0.9689 + yr * 1.8758 + zr * 0.0415
        let b = xr * 0.0557 + yr * -0.2040 + zr * 1.0570

        let toSRGB = { (c: Double) -> Int in
            let v = c > 0.0031308 ? 1.055 * pow(c, 1 / 2.4) - 0.055 : c * 12.92
            return max(0, min(255, Int(round(v * 255))))
        }

        return String(format: "#%02X%02X%02X", toSRGB(r), toSRGB(g), toSRGB(b))
    }
}
