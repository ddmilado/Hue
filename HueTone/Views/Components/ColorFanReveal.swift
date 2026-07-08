import SwiftUI

struct ColorFanReveal: View {
    let swatches: [PaletteSwatch]
    var isBlurred: Bool = false
    var onRevealComplete: (() -> Void)?
    var animateImmediately: Bool = true

    @State private var fanSpread: Double = 0
    @State private var visible: Double = 0
    @State private var sliceAlphas: [Double] = Array(repeating: 0, count: 12)

    private static let fanCount = 12

    private let fanColors: [Color] = {
        (0..<fanCount).map { i in
            let hue = Double(i) / Double(fanCount)
            let bri = 0.8 + (i % 2 == 0 ? 0.1 : -0.1)
            return Color(hue: hue, saturation: 0.7, brightness: bri)
        }
    }()

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.9)
            let sliceHeight = geo.size.height * 0.4 * fanSpread

            ZStack {
                ForEach(0..<Self.fanCount, id: \.self) { i in
                    let angle = -(Double(Self.fanCount) / 2 * 5 - Double(i) * 5)
                    let rad = angle * .pi / 180
                    FanSlice(center: center, angle: rad, height: sliceHeight)
                        .fill(fanColor(i: i))
                        .opacity(sliceAlphas[i])
                    FanSlice(center: center, angle: rad, height: sliceHeight)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                        .opacity(sliceAlphas[i])
                }
            }
        }
        .opacity(visible)
        .onAppear {
            guard animateImmediately else { return }
            startAnimation()
        }
    }

    func startAnimation() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            fanSpread = 1
            visible = 1
        }
        for i in 0..<Self.fanCount {
            withAnimation(.easeOut(duration: 0.4).delay(Double(i) * 0.05)) {
                sliceAlphas[i] = 1
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            onRevealComplete?()
        }
    }

    private func fanColor(i: Int) -> Color {
        let c = fanColors[i]
        return isBlurred ? c.opacity(0.2) : c
    }
}

private struct FanSlice: Shape {
    let center: CGPoint
    let angle: Double
    let height: Double

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: center)
            p.addLine(to: CGPoint(
                x: center.x + sin(angle - 0.04) * height,
                y: center.y - cos(angle - 0.04) * height
            ))
            p.addLine(to: CGPoint(
                x: center.x + sin(angle + 0.04) * height * 0.85,
                y: center.y - cos(angle + 0.04) * height * 0.85
            ))
            p.closeSubpath()
        }
    }
}
