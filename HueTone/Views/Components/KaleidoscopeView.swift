import SwiftUI

struct KaleidoscopeView: View {
    @State private var rotation: Double = 0
    var speed: Double = 8

    let gradientColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink
    ]

    var body: some View {
        TimelineView(.animation(minimumInterval: 0.02)) { _ in
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let count = 12

                for i in 0..<count {
                    let angle = (Double(i) / Double(count)) * 360 + rotation
                    let slice = Path { path in
                        path.move(to: center)
                        path.addArc(center: center, radius: max(size.width, size.height) * 1.5,
                                   startAngle: .degrees(angle - 15),
                                   endAngle: .degrees(angle + 15),
                                   clockwise: false)
                        path.closeSubpath()
                    }

                    let color = gradientColors[i % gradientColors.count].opacity(0.3)
                    context.fill(slice, with: .color(color))
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: speed).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}
