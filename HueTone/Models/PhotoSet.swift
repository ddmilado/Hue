import Foundation
import SwiftUI

struct PhotoSet: Codable, Identifiable {
    let id: UUID
    let userId: UUID?
    let capturedAt: Date
    var rawImagePaths: [String]
    var calibrationCardDetected: Bool
    var whiteBalanceTransform: [Float]

    init(id: UUID = UUID(), userId: UUID? = nil, capturedAt: Date = Date(),
         rawImagePaths: [String] = [], calibrationCardDetected: Bool = false,
         whiteBalanceTransform: [Float] = [1.0, 0, 0, 0, 1.0, 0, 0, 0, 1.0]) {
        self.id = id
        self.userId = userId
        self.capturedAt = capturedAt
        self.rawImagePaths = rawImagePaths
        self.calibrationCardDetected = calibrationCardDetected
        self.whiteBalanceTransform = whiteBalanceTransform
    }
}
