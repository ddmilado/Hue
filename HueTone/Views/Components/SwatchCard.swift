import SwiftUI

struct SwatchCard: View {
    let swatch: PaletteSwatch
    let size: CGFloat

    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: swatch.hexValue))
                .frame(width: size, height: size * 0.6)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                )

            Text(swatch.colorName)
                .font(.caption)
                .foregroundColor(Color(hex: "#8B8290"))
                .lineLimit(1)

            Text(swatch.hexValue)
                .font(.caption2)
                .foregroundColor(Color(hex: "#8B8290").opacity(0.7))
        }
        .frame(width: size)
    }
}
