import SwiftUI

struct DrapeSimulatorView: View {
    @EnvironmentObject var themeManager: ThemeManager

    let categories: [SwatchCategory] = [.metal, .white, .brown, .black, .gray, .navy]

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Drape Simulator")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding(.top, 8)

                Text("See how different colors work with your complexion")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color(hex: "#8B8290"))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { cat in
                            CategoryPill(category: cat, isSelected: true)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#2A2729"))
                        .frame(height: 200)

                    Image(systemName: "person.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color(hex: "#F7F2EC").opacity(0.2))
                }
                .padding(.horizontal, 40)

                VStack(spacing: 12) {
                    DrapeSwatchRow(hex: "#C0C0C0", name: "Silver", score: 0.85, tag: "Best")
                    DrapeSwatchRow(hex: "#FFD700", name: "Gold", score: 0.92, tag: "Best")
                    DrapeSwatchRow(hex: "#B76E79", name: "Rose Gold", score: 0.65, tag: "Good")
                    DrapeSwatchRow(hex: "#71797E", name: "Gunmetal", score: 0.30, tag: "Avoid")
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }
}

struct CategoryPill: View {
    let category: SwatchCategory
    var isSelected: Bool = false

    var body: some View {
        Text(category.rawValue.capitalized)
            .font(.custom("Inter", size: 14))
            .foregroundColor(isSelected ? .white : Color(hex: "#8B8290"))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color(hex: "#C8A86E") : Color(hex: "#2A2729"))
            .cornerRadius(20)
    }
}

struct DrapeSwatchRow: View {
    let hex: String
    let name: String
    let score: Double
    let tag: String

    var tagColor: Color {
        switch tag {
        case "Best": return .green
        case "Good": return .orange
        default: return .red
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: hex))
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.custom("Inter", size: 15))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                Text(hex)
                    .font(.caption2)
                    .foregroundColor(Color(hex: "#8B8290"))
            }

            Spacer()

            Text(tag)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(tagColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(tagColor.opacity(0.15))
                .cornerRadius(6)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(hex: "#2A2729"))
        .cornerRadius(12)
    }
}
