import Foundation
import AuthenticationServices
import Combine

@MainActor
final class AuthService: ObservableObject {
    static let shared = AuthService()

    @Published var currentUser: AuthUser?
    @Published var isAuthenticated = false
    @Published var subscriptionTier: String = "free"

    private let supabase = SupabaseService.shared

    private init() {
        currentUser = supabase.currentUser
        isAuthenticated = currentUser != nil
    }

    func handleAppleSignIn(result: Result<ASAuthorization, Error>, completion: ((Bool) -> Void)? = nil) {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let idToken = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }) else {
                completion?(false)
                return
            }
            Task {
                do {
                    let user = try await supabase.signInWithApple(idToken: idToken, rawNonce: nil)
                    updateState(with: user)
                    await MainActor.run { completion?(true) }
                } catch {
                    print("Apple sign-in failed: \(error)")
                    await MainActor.run { completion?(false) }
                }
            }
        case .failure(let error):
            print("Apple sign-in cancelled: \(error)")
            completion?(false)
        }
    }

    func handleGoogleSignIn(idToken: String) async throws {
        let user = try await supabase.signInWithGoogle(idToken: idToken)
        updateState(with: user)
    }

    func signUp(email: String, password: String) async throws {
        let user = try await supabase.signUp(email: email, password: password)
        updateState(with: user)
    }

    func signIn(email: String, password: String) async throws {
        let user = try await supabase.signIn(email: email, password: password)
        updateState(with: user)
    }

    func signOut() async throws {
        try await supabase.signOut()
        currentUser = nil
        isAuthenticated = false
        subscriptionTier = "free"
    }

    func refreshSubscriptionStatus() async {
        guard isAuthenticated else { return }
        do {
            let profile = try await supabase.getProfile()
            subscriptionTier = profile.subscription_tier
        } catch {
            subscriptionTier = "free"
        }
    }

    var isPremium: Bool {
        subscriptionTier == "premium"
    }

    func continueAsGuest() {
        currentUser = AuthUser(id: UUID(), email: nil)
        isAuthenticated = true
        subscriptionTier = "free"
    }

    private func updateState(with user: AuthUser) {
        currentUser = user
        isAuthenticated = true
        Task { await refreshSubscriptionStatus() }
    }
}
