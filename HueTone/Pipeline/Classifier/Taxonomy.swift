import Foundation

struct SeasonTaxonomy {

    static let seasonDescriptions: [Season: String] = [
        .lightSpring: "Warm, light, and clear — your best colors are fresh pastels and warm, bright tones.",
        .trueSpring: "The purest warm season — you shine in clear, warm yellows, corals, and bright greens.",
        .brightSpring: "Warm and high-contrast — vivid, saturated colors are your power palette.",
        .lightSummer: "Cool, light, and soft — think dusty roses, powder blues, and gentle lavenders.",
        .trueSummer: "The quintessential cool season — rose, mauve, and soft blue-gray are your naturals.",
        .softSummer: "Cool and muted — smoky blues, dusty pinks, and sage greens suit you best.",
        .softAutumn: "Warm and muted — olive, khaki, warm browns, and muted teal are your terrain.",
        .trueAutumn: "Warm, rich, and earthy — rust, amber, moss green, and deep gold define your palette.",
        .deepAutumn: "Warm and deep — espresso brown, deep olive, burnt orange, and bronze.",
        .brightWinter: "Cool and high-contrast — icy pink, stark white, true red, and cobalt blue.",
        .trueWinter: "The purest cool season — cool red, emerald, sapphire, and stark black and white.",
        .deepWinter: "Cool and deep — black cherry, deep navy, charcoal, and burgundy.",

        .softSpring: "You bridge Spring and Summer — warm-leaning but muted, like a gentle pastel.",
        .lightAutumn: "You bridge Spring and Autumn — warm, slightly deeper, but still clear.",
        .deepSummer: "You bridge Summer and Winter — cool, deeper than a classic Summer.",
        .softWinter: "You bridge Autumn and Winter — cool-leaning but muted, not stark."
    ]

    static func description(for season: Season) -> String {
        seasonDescriptions[season] ?? "A unique blend of tones that defines your personal palette."
    }
}
