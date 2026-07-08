import SwiftUI

struct LiveCaptureView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showReview = false
    @State private var paperDetected = false
    @State private var faceCentered = false
    @State private var lightingLevel: Double = 0.7
    @State private var hasCaptured = false

    private var canCapture: Bool {
        paperDetected && faceCentered && lightingLevel > 0.5 && !hasCaptured
    }

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#2A2729"))
                        .aspectRatio(3/4, contentMode: .fit)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "#C8A86E").opacity(faceCentered ? 1 : 0.3), lineWidth: 2)
                        )

                    VStack(spacing: 12) {
                        Image(systemName: "faceid")
                            .font(.system(size: 48))
                            .foregroundColor(Color(hex: "#F7F2EC").opacity(0.3))
                        Text("Center your face in the frame")
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(Color(hex: "#8B8290"))
                    }

                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: paperDetected ? "doc.plaintext.fill" : "doc.plaintext")
                                .font(.title3)
                                .foregroundColor(paperDetected ? .green : Color(hex: "#8B8290"))
                                .padding(8)
                                .background(Circle().fill(Color.black.opacity(0.5)))
                                .padding()
                        }
                        Spacer()
                    }
                }
                .padding()

                LightingMeter(level: lightingLevel, label: "Lighting quality")
                    .padding(.horizontal, 32)

                HStack(spacing: 12) {
                    if !paperDetected {
                        StatusBadge(text: "Hold paper in frame", icon: "doc.plaintext")
                    }
                    if !faceCentered {
                        StatusBadge(text: "Center your face", icon: "faceid")
                    }
                    if lightingLevel < 0.5 {
                        StatusBadge(text: "Move to better light", icon: "sun.max")
                    }
                }
                .padding(.horizontal)

                Spacer()

                Button(action: {
                    hasCaptured = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showReview = true
                    }
                }) {
                    Circle()
                        .fill(Color(hex: canCapture ? "#C8A86E" : "#8B8290"))
                        .frame(width: 72, height: 72)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                                .frame(width: 64, height: 64)
                        )
                }
                .disabled(!canCapture)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showReview) {
            ReviewRetakeView()
        }
    }
}

struct StatusBadge: View {
    let text: String
    let icon: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption2)
        }
        .foregroundColor(Color(hex: "#F7F2EC"))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(hex: "#8B8290").opacity(0.2))
        .cornerRadius(8)
    }
}
