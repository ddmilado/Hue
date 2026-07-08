import SwiftUI

struct DynamicAccent: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager

    func body(content: Content) -> some View {
        content.foregroundColor(themeManager.accentSafeColor)
    }
}

extension View {
    func dynamicAccent() -> some View {
        modifier(DynamicAccent())
    }
}

struct DynamicAccentFill: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager

    func body(content: Content) -> some View {
        content.foregroundColor(.white)
            .background(themeManager.accentSafeColor)
            .cornerRadius(12)
    }
}

extension View {
    func dynamicAccentFill() -> some View {
        modifier(DynamicAccentFill())
    }
}
