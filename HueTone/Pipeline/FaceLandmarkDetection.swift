import Foundation
import SwiftUI

struct FaceRegion {
    let cheek: CGRect
    let forehead: CGRect
    let jaw: CGRect
    let underEye: CGRect
    let hairRegion: CGRect
    let irisRegion: CGRect
}

class FaceLandmarkDetector {

    func detectLandmarks(in image: UIImage) -> FaceRegion? {
        nil
    }
}
