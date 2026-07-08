import Foundation
import SwiftUI

struct SampledColors {
    let skinLab: LabValue
    let hairLab: LabValue
    let eyeLab: LabValue
    let sampleCount: Int
    let outlierRejectionRate: Double
}

class RegionSampler {

    func sampleRegions(from image: UIImage, regions: FaceRegion) -> SampledColors {
        SampledColors(
            skinLab: LabValue(L: 60, a: 10, b: 15),
            hairLab: LabValue(L: 25, a: 2, b: 5),
            eyeLab: LabValue(L: 35, a: -5, b: 10),
            sampleCount: 250,
            outlierRejectionRate: 0.08
        )
    }
}
