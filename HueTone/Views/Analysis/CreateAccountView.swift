import SwiftUI
import AuthenticationServices

struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var authService: AuthService
    @State private var showResults = false
    @State private var showEmailSignIn = false
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSigningIn = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("One step to unlock\nyour results.")
                    .font(.custom("Fraunces", size: 32))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("One step to unlock your results")

                Spacer()

                if showEmailSignIn {
                    emailSignInForm
                } else {
                    signInOptions
                }

                Text("By continuing, you agree to our Terms and Privacy Policy.")
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()
            }
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showResults) {
            Big5ResultsView()
        }
    }

    private var signInOptions: some View {
        VStack(spacing: 16) {
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    authService.handleAppleSignIn(result: result)
                    if authService.isAuthenticated {
                        completeSignIn()
                    }
                }
            )
            .frame(height: 50)
            .cornerRadius(12)
            .accessibilityLabel("Continue with Apple")

            SignInButton(
                icon: "g.circle.fill",
                text: "Continue with Google",
                color: Color(hex: "#4285F4"),
                action: {
                    alertMessage = "Google Sign-In requires GoogleSignIn SDK setup."
                    showAlert = true
                }
            )

            SignInButton(
                icon: "envelope.fill",
                text: "Continue with email",
                color: themeManager.accentSafeColor,
                action: { withAnimation { showEmailSignIn = true } }
            )
        }
        .padding(.horizontal, 24)
    }

    private var emailSignInForm: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .textFieldStyle(.plain)
                .font(.custom("Inter", size: 16))
                .foregroundColor(Color(hex: "#F7F2EC"))
                .padding()
                .background(Color(hex: "#2A2729"))
                .cornerRadius(12)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .accessibilityLabel("Email address")

            SecureField("Password", text: $password)
                .textFieldStyle(.plain)
                .font(.custom("Inter", size: 16))
                .foregroundColor(Color(hex: "#F7F2EC"))
                .padding()
                .background(Color(hex: "#2A2729"))
                .cornerRadius(12)
                .accessibilityLabel("Password")

            Button(action: {
                guard !email.isEmpty, !password.isEmpty else {
                    alertMessage = "Please enter an email and password."
                    showAlert = true
                    return
                }
                isSigningIn = true
                Task {
                    defer { isSigningIn = false }
                    do {
                        try await authService.signUp(email: email, password: password)
                        completeSignIn()
                    } catch {
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }) {
                Text("Sign Up")
                    .font(.custom("Inter", size: 17, relativeTo: .body))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(themeManager.accentSafeColor)
                    .cornerRadius(12)
            }
            .accessibilityLabel("Sign up with email")

            Button(action: { withAnimation { showEmailSignIn = false } }) {
                Text("Back to sign-in options")
                    .font(.custom("Inter", size: 15))
                    .foregroundColor(Color(hex: "#8B8290"))
            }
            .accessibilityLabel("Back to sign in options")
        }
        .padding(.horizontal, 24)
    }

    private func completeSignIn() {
        navigationState.hasCompletedOnboarding = true
        navigationState.currentAnalysisState = .completed
        showResults = true
    }
}

struct SignInButton: View {
    let icon: String
    let text: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                Text(text)
                    .font(.custom("Inter", size: 16, relativeTo: .body))
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color.opacity(0.2))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
