import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var authService: AuthService
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showUpgrade = false
    @State private var showCapture = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Profile")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding(.top, 12)

                VStack(spacing: 0) {
                    ProfileRow(
                        icon: "person.circle",
                        title: "Account",
                        subtitle: authService.currentUser?.email ?? (authService.isAuthenticated ? "Guest" : "Not signed in"),
                        themeManager: themeManager
                    )
                    Divider().background(Color(hex: "#2A2729"))
                    Button(action: { showUpgrade = true }) {
                        ProfileRow(
                            icon: "crown",
                            title: "Subscription",
                            subtitle: authService.isPremium ? "Premium" : "Free tier",
                            themeManager: themeManager,
                            showChevron: !authService.isPremium
                        )
                    }
                    Divider().background(Color(hex: "#2A2729"))
                    Button(action: { showCapture = true }) {
                        ProfileRow(
                            icon: "camera.aperture",
                            title: "Retake Analysis",
                            subtitle: nil,
                            themeManager: themeManager
                        )
                    }
                    Divider().background(Color(hex: "#2A2729"))
                    ProfileRow(
                        icon: "bell",
                        title: "Notifications",
                        subtitle: nil,
                        themeManager: themeManager
                    )
                }
                .background(Color(hex: "#2A2729").opacity(0.3))
                .cornerRadius(16)
                .padding(.horizontal, 24)

                VStack(spacing: 0) {
                    ProfileRow(
                        icon: "lock.shield",
                        title: "Privacy Policy",
                        subtitle: nil,
                        themeManager: themeManager
                    )
                    Divider().background(Color(hex: "#2A2729"))
                    ProfileRow(
                        icon: "doc.text",
                        title: "Terms of Service",
                        subtitle: nil,
                        themeManager: themeManager
                    )
                    Divider().background(Color(hex: "#2A2729"))
                    ProfileRow(
                        icon: "info.circle",
                        title: "Affiliate Disclosure",
                        subtitle: nil,
                        themeManager: themeManager
                    )
                }
                .background(Color(hex: "#2A2729").opacity(0.3))
                .cornerRadius(16)
                .padding(.horizontal, 24)

                Spacer()

                if authService.isAuthenticated {
                    Button(action: signOut) {
                        HStack(spacing: 8) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.red.opacity(0.8))
                    }
                    .padding(.bottom, 40)
                    .accessibilityLabel("Sign out")
                }
            }
        }
        .fullScreenCover(isPresented: $showCapture) {
            CapturePrepView()
        }
        .fullScreenCover(isPresented: $showUpgrade) {
            UpgradePremiumView()
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    private func signOut() {
        Task {
            do {
                try await authService.signOut()
                alertMessage = "Signed out successfully."
                showAlert = true
            } catch {
                alertMessage = "Failed to sign out: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let themeManager: ThemeManager
    var showChevron: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(themeManager.accentSafeColor)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Inter", size: 15))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Color(hex: "#8B8290"))
                }
            }

            Spacer()

            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(hex: "#8B8290"))
                    .font(.caption)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
