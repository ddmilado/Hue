import SwiftUI

struct CalibrationInstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showCapture = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "doc.viewfinder")
                    .font(.system(size: 72))
                    .foregroundColor(Color(hex: "#C8A86E"))

                Text("Calibration Step")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))

                Text("Hold the paper next to your face,\nnot over it. We use it to correct for\nyour camera's color balance.")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                        .frame(height: 200)

                    VStack(spacing: 8) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 48))
                            .foregroundColor(Color(hex: "#F7F2EC").opacity(0.5))
                        Image(systemName: "doc.plaintext")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .offset(x: 50, y: -10)
                    }
                }
                .padding(.horizontal, 40)

                Spacer()

                Button(action: { showCapture = true }) {
                    Text("Open Camera")
                        .font(.custom("Inter", size: 17, relativeTo: .body))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "#C8A86E"))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showCapture) {
            LiveCaptureView()
        }
    }
}
