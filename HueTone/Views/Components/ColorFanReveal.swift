import SwiftUI

struct ColorFanReveal: View {
    let swatches: [PaletteSwatch]
    var isBlurred: Bool = false
    var onRevealComplete: (() -> Void)?

    @State private var fanSpread: Double = 0
    @State private var opacity: Double = 0

    private let fanCount = 12

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height * 0.9)
            let swatchH = size.height * 0.4 * fanSpread

            for i in 0..<fanCount {
                let angle = -(Double(fanCount) / 2 * 5 - Double(i) * 5) * .pi / 180
                let path = Path { p in
                    p.move(to: center)
                    p.addLine(to: CGPoint(x: center.x + sin(angle - 0.04) * swatchH,
                                         y: center.y - cos(angle - 0.04) * swatchH))
                    p.addLine(to: CGPoint(x: center.x + sin(angle + 0.04) * swatchH * 0.85,
                                         y: center.y - cos(angle + 0.04) * swatchH * 0.85))
                    p.closeSubpath()
                }

                let hue = Double(i) / Double(fanCount)
                let color = Color(hue: hue, saturation: 0.7, brightness: 0.8 + (i % 2 == 0 ? 0.1 : -0.1))
                context.fill(path, with: .color(isBlurred ? color.opacity(0.2) : color))
                context.stroke(path, with: .color(.white.opacity(0.2)), lineWidth: 0.5)
            }
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                fanSpread = 1
                opacity = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                onRevealComplete?()
            }
        }
    }
}
