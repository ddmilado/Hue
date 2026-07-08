import SwiftUI

struct SeasonDeepDiveView: View {
    @Environment(\.dismiss) private var dismiss

    let season: Season = .deepAutumn

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text(season.rawValue)
                        .font(.custom("Fraunces", size: 34))
                        .foregroundColor(Color(hex: "#F7F2EC"))
                        .padding(.top, 60)

                    Text(SeasonTaxonomy.description(for: season))
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(Color(hex: "#8B8290"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Characteristics")
                            .font(.custom("Fraunces", size: 22))
                            .foregroundColor(Color(hex: "#F7F2EC"))

                        ForEach(["Warm undertone", "Medium-deep depth", "Rich, earthy chroma",
                                 "Warm contrast", "Golden/honey tones"], id: \.self) { trait in
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(Color(hex: "#C8A86E"))
                                    .frame(width: 6, height: 6)
                                Text(trait)
                                    .font(.custom("Inter", size: 15))
                                    .foregroundColor(Color(hex: "#F7F2EC"))
                            }
                        }
                    }
                    .padding(.horizontal, 32)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Best Colors")
                            .font(.custom("Fraunces", size: 22))
                            .foregroundColor(Color(hex: "#F7F2EC"))

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                            ForEach(["#8B4513", "#D2691E", "#CD853F", "#B8860B",
                                     "#DAA520", "#6B8E23", "#556B2F", "#A0522D"], id: \.self) { hex in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(hex: hex))
                                    .frame(height: 60)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 32)

                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Your Result")
                        }
                        .font(.custom("Inter", size: 16))
                        .foregroundColor(Color(hex: "#C8A86E"))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(Color(hex: "#C8A86E").opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding()
            }
        }
    }
}
