import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState
    @State private var showCapture = false
    @State private var showDeepDive = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if navigationState.analysesHistory.isEmpty {
                    emptyState
                } else {
                    historyList
                }
            }
        }
        .fullScreenCover(isPresented: $showCapture) {
            CapturePrepView()
        }
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("History")
                .font(.custom("Fraunces", size: 28))
                .foregroundColor(Color(hex: "#F7F2EC"))
                .padding(.top, 12)

            Button(action: { showCapture = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "camera.aperture")
                    Text("New Analysis")
                }
                .font(.custom("Inter", size: 15))
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(themeManager.accentSafeColor)
                .cornerRadius(12)
            }
            .pressable()
            .padding(.horizontal, 24)
            .padding(.bottom, 8)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 52))
                .foregroundColor(Color(hex: "#8B8290").opacity(0.6))
            Text("No analyses yet")
                .font(.custom("Fraunces", size: 20))
                .foregroundColor(Color(hex: "#F7F2EC"))
            Text("Complete your first color analysis\nto see it here.")
                .font(.custom("Inter", size: 14))
                .foregroundColor(Color(hex: "#8B8290"))
                .multilineTextAlignment(.center)
            Spacer()
        }
    }

    private var historyList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(navigationState.analysesHistory) { result in
                    Button(action: { navigationState.latestResult = result; showDeepDive = true }) {
                        HistoryRow(
                            season: result.season,
                            date: formattedDate(result.id),
                            confidence: result.confidence,
                            themeManager: themeManager
                        )
                    }
                    .pressable()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
        }
        .fullScreenCover(isPresented: $showDeepDive) {
            SeasonDeepDiveView()
        }
    }

    private func formattedDate(_ id: UUID) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: Date())
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
        .background(Color(hex: "#2A2729").opacity(0.3))
        .cornerRadius(12)
    }
}
