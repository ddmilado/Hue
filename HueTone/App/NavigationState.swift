import SwiftUI
import Combine

class NavigationState: ObservableObject {
    @Published var hasCompletedOnboarding = false
    @Published var currentAnalysisState: AnalysisState = .notStarted
    @Published var latestResult: SeasonResult?

    enum AnalysisState {
        case notStarted
        case capturing
        case processing
        case teaserReady
        case requiresAccount
        case completed
    }

    func reset() {
        hasCompletedOnboarding = false
        currentAnalysisState = .notStarted
        latestResult = nil
    }
}
