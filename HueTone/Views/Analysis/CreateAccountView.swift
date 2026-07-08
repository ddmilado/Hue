import SwiftUI

struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showResults = false
    @EnvironmentObject var navigationState: NavigationState

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("One step to unlock\nyour results.")
                    .font(.custom("Fraunces", size: 32))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .multilineTextAlignment(.center)

                Spacer()

                VStack(spacing: 16) {
                    SignInButton(icon: "applelogo", text: "Continue with Apple", color: .white)
                    SignInButton(icon: "g.circle.fill", text: "Continue with Google", color: Color(hex: "#4285F4"))
                    SignInButton(icon: "envelope.fill", text: "Continue with email", color: Color(hex: "#C8A86E"))
                }
                .padding(.horizontal, 24)

                Text("By continuing, you agree to our Terms and Privacy Policy.")
                    .font(.custom("Inter", size: 12))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()
            }
        }
        .onTapGesture {
            navigationState.hasCompletedOnboarding = true
            navigationState.currentAnalysisState = .completed
            showResults = true
        }
        .fullScreenCover(isPresented: $showResults) {
            Big5ResultsView()
        }
    }
}

struct SignInButton: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        Button(action: {}) {
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
