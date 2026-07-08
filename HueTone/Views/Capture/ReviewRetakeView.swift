import SwiftUI

struct ReviewRetakeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showProcessing = false
    @State private var qualityFlags: [String] = []
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("Review Your Photos")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .accessibilityLabel("Review your photos")

                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#2A2729"))
                        .aspectRatio(3/4, contentMode: .fit)

                    Image(systemName: "person.fill")
                        .font(.system(size: 64))
                        .foregroundColor(Color(hex: "#F7F2EC").opacity(0.3))
                }
                .padding(.horizontal, 32)

                if !qualityFlags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(qualityFlags, id: \.self) { flag in
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                                Text(flag)
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(Color(hex: "#8B8290"))
                            }
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal, 32)
                }

                Spacer()

                HStack(spacing: 16) {
                    Button(action: { dismiss() }) {
                        Text("Retake")
                            .font(.custom("Inter", size: 17, relativeTo: .body))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "#F7F2EC"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "#2A2729"))
                            .cornerRadius(12)
                    }
                    .accessibilityLabel("Retake photo")

                    Button(action: { showProcessing = true }) {
                        Text("Looks good")
                            .font(.custom("Inter", size: 17, relativeTo: .body))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(themeManager.accentSafeColor)
                            .cornerRadius(12)
                    }
                    .pressable()
                    .accessibilityLabel("Looks good, start analysis")
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showProcessing) {
            ProcessingView()
        }
    }
}
