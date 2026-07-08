import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState
    @State private var showCapture = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 16) {
                Text("History")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding(.top, 8)
                    .accessibilityLabel("Analysis history")

                Button(action: { showCapture = true }) {
                    Text("Retake Analysis")
                        .font(.custom("Inter", size: 15))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(themeManager.accentSafeColor)
                        .cornerRadius(12)
                }
                .pressable()
                .padding(.horizontal, 24)
                .accessibilityLabel("Retake analysis")

                if let result = navigationState.latestResult {
                    VStack(spacing: 0) {
                        HistoryRow(
                            season: result.season,
                            date: "Today",
                            confidence: result.confidence,
                            themeManager: themeManager
                        )
                    }
                    .background(Color(hex: "#2A2729").opacity(0.3))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
                } else {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 48))
                            .foregroundColor(Color(hex: "#8B8290"))
                        Text("No analyses yet")
                            .font(.custom("Inter", size: 16))
                            .foregroundColor(Color(hex: "#8B8290"))
                        Text("Complete your first color analysis\nto see it here.")
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(Color(hex: "#8B8290").opacity(0.7))
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(.horizontal, 32)
                }

                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showCapture) {
            CapturePrepView()
        }
    }
}

struct HistoryRow: View {
    let season: Season
    let date: String
    let confidence: Double
    let themeManager: ThemeManager

    var body: some View {
        HStack {
            Circle()
                .fill(themeManager.accentSafeColor)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(season.rawValue.prefix(2)))
                        .font(.caption)
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(season.rawValue)
                    .font(.custom("Inter", size: 15, relativeTo: .body))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                Text("\(date) · \(Int(confidence * 100))% confidence")
                    .font(.caption)
                    .foregroundColor(Color(hex: "#8B8290"))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Color(hex: "#8B8290"))
                .font(.caption)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
