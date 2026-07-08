import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    let scale: CGFloat

    init(scale: CGFloat = 0.97) {
        self.scale = scale
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension View {
    func pressable(scale: CGFloat = 0.97) -> some View {
        self.buttonStyle(PressableButtonStyle(scale: scale))
    }
}

struct StaggeredAppear: ViewModifier {
    let index: Int
    let total: Int
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 20)
            .animation(
                .spring(response: 0.5, dampingFraction: 0.8)
                    .delay(Double(index) * 0.1),
                value: appeared
            )
            .onAppear { appeared = true }
    }
}

extension View {
    func staggeredAppear(index: Int, total: Int = 0) -> some View {
        modifier(StaggeredAppear(index: index, total: total))
    }
}
