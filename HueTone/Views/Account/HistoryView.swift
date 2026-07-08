import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 16) {
                Text("History")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding(.top, 8)

                Button(action: {}) {
                    Text("Retake Analysis")
                        .font(.custom("Inter", size: 15))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(themeManager.accentSafeColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)

                if true {
                    VStack(spacing: 0) {
                        HistoryRow(season: .deepAutumn, date: "Mar 15, 2026", confidence: 92)
                        Divider().background(Color(hex: "#2A2729"))
                        HistoryRow(season: .trueAutumn, date: "Jan 8, 2026", confidence: 78)
                        Divider().background(Color(hex: "#2A2729"))
                        HistoryRow(season: .softAutumn, date: "Oct 22, 2025", confidence: 65)
                    }
                    .background(Color(hex: "#2A2729").opacity(0.3))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
        }
    }
}

struct HistoryRow: View {
    let season: Season
    let date: String
    let confidence: Double

    var body: some View {
        HStack {
            Circle()
                .fill(Color(hex: "#C8A86E"))
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
