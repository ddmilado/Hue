import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Profile")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding(.top, 8)

                VStack(spacing: 0) {
                    ProfileRow(icon: "person.circle", title: "Account", subtitle: "email@example.com")
                    Divider().background(Color(hex: "#2A2729"))
                    ProfileRow(icon: "crown", title: "Subscription", subtitle: "Free tier")
                    Divider().background(Color(hex: "#2A2729"))
                    ProfileRow(icon: "camera.aperture", title: "Retake Analysis", subtitle: nil)
                    Divider().background(Color(hex: "#2A2729"))
                    ProfileRow(icon: "bell", title: "Notifications", subtitle: nil)
                }
                .background(Color(hex: "#2A2729").opacity(0.3))
                .cornerRadius(16)
                .padding(.horizontal, 24)

                VStack(spacing: 0) {
                    ProfileRow(icon: "lock.shield", title: "Privacy Policy", subtitle: nil)
                    Divider().background(Color(hex: "#2A2729"))
                    ProfileRow(icon: "doc.text", title: "Terms of Service", subtitle: nil)
                    Divider().background(Color(hex: "#2A2729"))
                    ProfileRow(icon: "info.circle", title: "Affiliate Disclosure", subtitle: nil)
                }
                .background(Color(hex: "#2A2729").opacity(0.3))
                .cornerRadius(16)
                .padding(.horizontal, 24)

                Spacer()

                Button(action: {}) {
                    Text("Sign Out")
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(.red.opacity(0.8))
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    let subtitle: String?

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#C8A86E"))
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

            Image(systemName: "chevron.right")
                .foregroundColor(Color(hex: "#8B8290"))
                .font(.caption)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
