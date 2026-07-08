import Foundation

#if canImport(Supabase)
import Supabase

final class SupabaseService {
    static let shared = SupabaseService()

    let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: Config.supabaseURL,
            supabaseKey: Config.supabaseAnonKey
        )
    }

    // MARK: - Auth

    func signInWithApple(idToken: String, rawNonce: String?) async throws -> AuthUser {
        let session = try await client.auth.signInWithIdToken(
            credentials: .init(
                provider: .apple,
                idToken: idToken,
                nonce: rawNonce
            )
        )
        return AuthUser(id: session.user.id, email: session.user.email)
    }

    func signInWithGoogle(idToken: String) async throws -> AuthUser {
        let session = try await client.auth.signInWithIdToken(
            credentials: .init(
                provider: .google,
                idToken: idToken
            )
        )
        return AuthUser(id: session.user.id, email: session.user.email)
    }

    func signUp(email: String, password: String) async throws -> AuthUser {
        let session = try await client.auth.signUp(
            email: email,
            password: password
        )
        return AuthUser(id: session.user.id, email: session.user.email)
    }

    func signIn(email: String, password: String) async throws -> AuthUser {
        let session = try await client.auth.signIn(
            email: email,
            password: password
        )
        return AuthUser(id: session.user.id, email: session.user.email)
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    var currentUser: AuthUser? {
        guard let user = client.auth.currentUser else { return nil }
        return AuthUser(id: user.id, email: user.email)
    }

    // MARK: - Database

    func saveResult(_ result: SeasonResult) async throws {
        let userID = client.auth.currentUser?.id.uuidString ?? ""
        let payload = ResultPayload(
            id: result.id.uuidString,
            user_id: userID,
            season: result.season.rawValue,
            confidence: result.confidence,
            classification_method: result.classificationMethod.rawValue,
            secondary_season: result.secondarySeason?.rawValue,
            color_metrics: nil
        )
        try await client.database
            .from("results")
            .upsert(payload, onConflict: "id")
            .execute()
    }

    func loadResults() async throws -> [SeasonResult] {
        let userID = client.auth.currentUser?.id.uuidString ?? ""
        let response = try await client.database
            .from("results")
            .select()
            .eq("user_id", value: userID)
            .order("created_at", ascending: false)
            .execute()
        let payloads = try response.decode([ResultPayload].self)
        return payloads.compactMap { $0.toSeasonResult() }
    }

    func deleteResult(id: String) async throws {
        try await client.database
            .from("results")
            .delete()
            .eq("id", value: id)
            .execute()
    }

    func saveSwatches(_ swatches: [PaletteSwatch]) async throws {
        let userID = client.auth.currentUser?.id.uuidString ?? ""
        let payloads = swatches.map { swatch in
            SwatchPayload(
                id: swatch.id.uuidString,
                user_id: userID,
                season: swatch.season.rawValue,
                category: swatch.category.rawValue,
                hex_value: swatch.hexValue,
                color_name: swatch.colorName,
                harmony_score: swatch.harmonyScore,
                lab_l: swatch.lab.L,
                lab_a: swatch.lab.a,
                lab_b: swatch.lab.b
            )
        }
        try await client.database
            .from("color_wallet")
            .upsert(payloads, onConflict: "id")
            .execute()
    }

    func loadSwatches() async throws -> [PaletteSwatch] {
        let userID = client.auth.currentUser?.id.uuidString ?? ""
        let response = try await client.database
            .from("color_wallet")
            .select()
            .eq("user_id", value: userID)
            .execute()
        let payloads = try response.decode([SwatchPayload].self)
        return payloads.map { $0.toPaletteSwatch() }
    }

    // MARK: - Profile

    func getProfile() async throws -> ProfilePayload {
        let userID = client.auth.currentUser?.id.uuidString ?? ""
        let response = try await client.database
            .from("profiles")
            .select()
            .eq("id", value: userID)
            .single()
            .execute()
        return try response.decode(ProfilePayload.self)
    }

    func updateSubscriptionTier(_ tier: String) async throws {
        let userID = client.auth.currentUser?.id.uuidString ?? ""
        try await client.database
            .from("profiles")
            .update(["subscription_tier": tier])
            .eq("id", value: userID)
            .execute()
    }
}

// MARK: - DTOs

private struct ResultPayload: Codable {
    let id: String
    let user_id: String
    let season: String
    let confidence: Double
    let classification_method: String
    let secondary_season: String?
    let color_metrics: String?

    func toSeasonResult() -> SeasonResult? {
        guard let season = Season(rawValue: season),
              let method = ClassificationMethod(rawValue: classification_method) else {
            return nil
        }
        let secondary = secondary_season.flatMap { Season(rawValue: $0) }
        return SeasonResult(
            id: UUID(uuidString: id) ?? UUID(),
            colorMetricsId: UUID(),
            season: season,
            confidence: confidence,
            classificationMethod: method,
            secondarySeason: secondary
        )
    }
}

private struct SwatchPayload: Codable {
    let id: String
    let user_id: String
    let season: String
    let category: String
    let hex_value: String
    let color_name: String
    let harmony_score: Double
    let lab_l: Double
    let lab_a: Double
    let lab_b: Double

    func toPaletteSwatch() -> PaletteSwatch {
        PaletteSwatch(
            id: UUID(uuidString: id) ?? UUID(),
            season: Season(rawValue: season) ?? .trueSpring,
            category: SwatchCategory(rawValue: category) ?? .neutral,
            hexValue: hex_value,
            colorName: color_name,
            harmonyScore: harmony_score,
            lab: LabValue(L: lab_l, a: lab_a, b: lab_b)
        )
    }
}

private struct ProfilePayload: Codable {
    let id: String
    let email: String?
    let subscription_tier: String
    let onboarding_completed: Bool?
}

#else

// Stub implementation that compiles without Supabase SDK.
// Replace by adding supabase-swift SPM package and removing this #else block.
final class SupabaseService {
    static let shared = SupabaseService()
    private init() {}

    var currentUser: AuthUser? { nil }

    func signInWithApple(idToken: String, rawNonce: String?) async throws -> AuthUser {
        throw SupabaseError.notConfigured
    }
    func signInWithGoogle(idToken: String) async throws -> AuthUser {
        throw SupabaseError.notConfigured
    }
    func signUp(email: String, password: String) async throws -> AuthUser {
        throw SupabaseError.notConfigured
    }
    func signIn(email: String, password: String) async throws -> AuthUser {
        throw SupabaseError.notConfigured
    }
    func signOut() async throws {
        throw SupabaseError.notConfigured
    }
    func saveResult(_ result: SeasonResult) async throws {
        throw SupabaseError.notConfigured
    }
    func loadResults() async throws -> [SeasonResult] { [] }
    func deleteResult(id: String) async throws {}
    func saveSwatches(_ swatches: [PaletteSwatch]) async throws {}
    func loadSwatches() async throws -> [PaletteSwatch] { [] }
    func getProfile() async throws -> ProfilePayload {
        throw SupabaseError.notConfigured
    }
    func updateSubscriptionTier(_ tier: String) async throws {}

    struct ProfilePayload: Codable {
        let id: String
        let email: String?
        let subscription_tier: String
        let onboarding_completed: Bool?
    }
}

enum SupabaseError: LocalizedError {
    case notConfigured
    var errorDescription: String? { "Supabase not configured — add supabase-swift SPM package" }
}

#endif

struct AuthUser {
    let id: UUID
    let email: String?
}
