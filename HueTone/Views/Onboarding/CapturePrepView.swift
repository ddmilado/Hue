import SwiftUI

struct CapturePrepView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showCalibration = false
    @EnvironmentObject var themeManager: ThemeManager

    let items = [
        ("No makeup", "face.smiling"),
        ("Hair pulled back", "scissors"),
        ("Facing a window, no overhead light", "sun.max"),
        ("Plain white paper in hand", "doc.plaintext")
    ]

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("A few things first.")
                    .font(.custom("Fraunces", size: 32))
                    .foregroundColor(Color(hex: "#F7F2EC"))

                VStack(alignment: .leading, spacing: 20) {
                    ForEach(items, id: \.0) { item in
                        HStack(spacing: 16) {
                            Image(systemName: item.1)
                                .font(.title3)
                                .foregroundColor(themeManager.accentSafeColor)
                                .frame(width: 32)

                            Text(item.0)
                                .font(.custom("Inter", size: 16))
                                .foregroundColor(Color(hex: "#F7F2EC"))
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 20)

                Spacer()

                Button(action: { showCalibration = true }) {
                    Text("I'm ready")
                        .font(.custom("Inter", size: 17, relativeTo: .body))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(themeManager.accentSafeColor)
                        .cornerRadius(12)
                }
                .pressable()
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .overlay(alignment: .topLeading) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding()
            }
            .accessibilityLabel("Go back")
        }
        .fullScreenCover(isPresented: $showCalibration) {
            CalibrationInstructionsView()
        }
    }
}
