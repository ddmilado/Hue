import SwiftUI
import Combine

class NavigationState: ObservableObject {
    @Published var hasCompletedOnboarding = false
    @Published var currentAnalysisState: AnalysisState = .notStarted
    @Published var latestResult: SeasonResult?
    @Published var analysesHistory: [SeasonResult] = []

    private let historyKey = "analyses_history"

    enum AnalysisState {
        case notStarted
        case capturing
        case processing
        case teaserReady
        case requiresAccount
        case completed
    }

    init() {
        loadHistory()
    }

    func saveCurrentResultToHistory() {
        guard let result = latestResult else { return }
        if !analysesHistory.contains(where: { $0.id == result.id }) {
            analysesHistory.insert(result, at: 0)
            persistHistory()
        }
    }

    func reset() {
        hasCompletedOnboarding = false
        currentAnalysisState = .notStarted
        latestResult = nil
    }

    private func loadHistory() {
        do {
            analysesHistory = try StorageService.shared.load([SeasonResult].self, for: historyKey)
        } catch {
            analysesHistory = []
        }
    }

    private func persistHistory() {
        try? StorageService.shared.save(analysesHistory, for: historyKey)
    }
}
