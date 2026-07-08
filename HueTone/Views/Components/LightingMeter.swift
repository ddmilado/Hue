import SwiftUI

struct LightingMeter: View {
    let level: Double
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundColor(Color(hex: "#8B8290"))

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 4)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(level > 0.6 ? Color.green : level > 0.3 ? Color.orange : Color.red)
                        .frame(width: geo.size.width * level, height: 4)
                }
            }
            .frame(height: 4)
        }
    }
}
