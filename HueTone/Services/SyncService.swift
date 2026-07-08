import Foundation
import Combine

@MainActor
final class SyncService: ObservableObject {
    static let shared = SyncService()

    @Published var isSyncing = false
    @Published var syncError: String?

    private let storage = StorageService.shared
    private let supabase = SupabaseService.shared
    private let auth = AuthService.shared
    private var cancellables = Set<AnyCancellable>()

    private init() {
        auth.$isAuthenticated
            .dropFirst()
            .sink { [weak self] authenticated in
                if authenticated {
                    self?.syncAll()
                }
            }
            .store(in: &cancellables)
    }

    func saveResult(_ result: SeasonResult) {
        try? storage.save([result], for: allResultsKey)
        guard auth.isAuthenticated else { return }
        Task { try? await supabase.saveResult(result) }
    }

    func saveSwatches(_ swatches: [PaletteSwatch]) {
        try? storage.save(swatches, for: walletKey)
        guard auth.isAuthenticated else { return }
        Task { try? await supabase.saveSwatches(swatches) }
    }

    func loadCachedResults() -> [SeasonResult] {
        (try? storage.load([SeasonResult].self, for: allResultsKey)) ?? []
    }

    func loadCachedSwatches() -> [PaletteSwatch] {
        (try? storage.load([PaletteSwatch].self, for: walletKey)) ?? []
    }

    func syncAll() {
        guard auth.isAuthenticated else { return }
        Task {
            isSyncing = true
            defer { isSyncing = false }

            do {
                let cloudResults = try await supabase.loadResults()
                try storage.save(cloudResults, for: allResultsKey)

                let cloudSwatches = try await supabase.loadSwatches()
                try storage.save(cloudSwatches, for: walletKey)

                syncError = nil
            } catch {
                syncError = "Sync failed: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - Keys

    private let allResultsKey = "all_results"
    private let walletKey = "color_wallet"
}
