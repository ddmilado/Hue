import SwiftUI

struct ProcessingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showTeaser = false
    @State private var currentLabel: String = "Depth"
    @State private var labelOpacity: Double = 1

    let labels = ["Depth", "Value", "Chroma", "Undertone", "Contrast"]

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            KaleidoscopeView(speed: 4)
                .opacity(0.3)

            VStack(spacing: 32) {
                Spacer()

                Text("Reading your undertones")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))

                Text(currentLabel)
                    .font(.custom("Fraunces", size: 48))
                    .foregroundColor(Color(hex: "#C8A86E"))
                    .opacity(labelOpacity)

                if showTeaser == false {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#C8A86E")))
                        .scaleEffect(1.5)
                }

                Spacer()

                Text("Still working — this can take a moment")
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .opacity(0.6)
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            cycleLabels()
        }
        .fullScreenCover(isPresented: $showTeaser) {
            TeaserRevealView()
        }
    }

    private func cycleLabels() {
        var index = 0
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.3)) {
                labelOpacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentLabel = labels[index]
                withAnimation(.easeInOut(duration: 0.3)) {
                    labelOpacity = 1
                }
                index += 1
                if index >= labels.count {
                    timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        showTeaser = true
                    }
                }
            }
        }
    }
}
