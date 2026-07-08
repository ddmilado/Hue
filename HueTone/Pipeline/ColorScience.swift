import Foundation
import SwiftUI

struct ColorScience {

    static func srgbToLab(r: Double, g: Double, b: Double) -> LabValue {
        let linearize = { (c: Double) -> Double in
            c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
        }

        let rl = linearize(r), gl = linearize(g), bl = linearize(b)

        let x = (rl * 0.4124564 + gl * 0.3575761 + bl * 0.1804375) * 100 / 95.047
        let y = (rl * 0.2126729 + gl * 0.7151522 + bl * 0.0721750) * 100 / 100.0
        let z = (rl * 0.0193339 + gl * 0.1191920 + bl * 0.9503041) * 100 / 108.883

        let fx = x > 0.008856 ? pow(x, 1/3) : (7.787 * x + 16/116)
        let fy = y > 0.008856 ? pow(y, 1/3) : (7.787 * y + 16/116)
        let fz = z > 0.008856 ? pow(z, 1/3) : (7.787 * z + 16/116)

        return LabValue(L: 116 * fy - 16, a: 500 * (fx - fy), b: 200 * (fy - fz))
    }

    static func deltaE2000(lab1: LabValue, lab2: LabValue) -> Double {
        let kL: Double = 1, kC: Double = 1, kH: Double = 1

        let L1 = lab1.L, a1 = lab1.a, b1 = lab1.b
        let L2 = lab2.L, a2 = lab2.a, b2 = lab2.b

        let C1 = sqrt(a1 * a1 + b1 * b1)
        let C2 = sqrt(a2 * a2 + b2 * b2)
        let Cb = (C1 + C2) / 2

        let G = 0.5 * (1 - sqrt(pow(Cb, 7) / (pow(Cb, 7) + pow(25, 7))))

        let a1p = a1 * (1 + G)
        let a2p = a2 * (1 + G)

        let C1p = sqrt(a1p * a1p + b1 * b1)
        let C2p = sqrt(a2p * a2p + b2 * b2)

        let h1p = atan2(b1, a1p) * 180 / .pi
        let h2p = atan2(b2, a2p) * 180 / .pi
        let h1pDeg = h1p < 0 ? h1p + 360 : h1p
        let h2pDeg = h2p < 0 ? h2p + 360 : h2p

        let dLp = L2 - L1
        let dCp = C2p - C1p

        var dhp: Double
        if C1p * C2p == 0 {
            dhp = 0
        } else if abs(h2pDeg - h1pDeg) <= 180 {
            dhp = h2pDeg - h1pDeg
        } else if h2pDeg - h1pDeg > 180 {
            dhp = h2pDeg - h1pDeg - 360
        } else {
            dhp = h2pDeg - h1pDeg + 360
        }

        let dHp = 2 * sqrt(C1p * C2p) * sin(dhp * .pi / 360)

        let Lbp = (L1 + L2) / 2
        let Cbp = (C1p + C2p) / 2

        var hbp: Double
        if C1p * C2p == 0 {
            hbp = h1pDeg + h2pDeg
        } else if abs(h1pDeg - h2pDeg) <= 180 {
            hbp = (h1pDeg + h2pDeg) / 2
        } else if h1pDeg + h2pDeg < 360 {
            hbp = (h1pDeg + h2pDeg + 360) / 2
        } else {
            hbp = (h1pDeg + h2pDeg - 360) / 2
        }

        let T = 1 - 0.17 * cos((hbp - 30) * .pi / 180)
            + 0.24 * cos((2 * hbp) * .pi / 180)
            + 0.32 * cos((3 * hbp + 6) * .pi / 180)
            - 0.20 * cos((4 * hbp - 63) * .pi / 180)

        let SL = 1 + (0.015 * pow(Lbp - 50, 2)) / sqrt(20 + pow(Lbp - 50, 2))
        let SC = 1 + 0.045 * Cbp
        let SH = 1 + 0.015 * Cbp * T

        let RT_denom = pow(Cbp, 7) + pow(25, 7)
        let dTheta = 30 * exp(-pow((hbp - 275) / 25, 2))
        let RC = 2 * sqrt(pow(Cbp, 7) / RT_denom)
        let RT = -RC * sin(2 * dTheta * .pi / 180)

        let dE = sqrt(
            pow(dLp / (kL * SL), 2) +
            pow(dCp / (kC * SC), 2) +
            pow(dHp / (kH * SH), 2) +
            RT * (dCp / (kC * SC)) * (dHp / (kH * SH))
        )

        return dE
    }

    static func harmonyScore(userLab: LabValue, swatchLab: LabValue, userContrast: Double) -> Double {
        let dE = deltaE2000(lab1: userLab, lab2: swatchLab)
        let contrastDiff = abs(userContrast - (abs(userLab.L - swatchLab.L) / 100))
        let score = max(0, 1 - (dE / 50) - (contrastDiff * 0.5))
        return min(1, score)
    }
}
