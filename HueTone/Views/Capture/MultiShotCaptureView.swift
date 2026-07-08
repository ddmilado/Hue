import SwiftUI

struct MultiShotCaptureView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showReview = false
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("One more angle")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))

                Text("Now turn slightly to your left\nfor an optional 3/4 profile shot.")
                    .font(.custom("Inter", size: 16))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .multilineTextAlignment(.center)

                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#2A2729"))
                        .aspectRatio(3/4, contentMode: .fit)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(themeManager.accentSafeColor.opacity(0.5), lineWidth: 2)
                        )

                    Image(systemName: "person.fill.viewfinder")
                        .font(.system(size: 48))
                        .foregroundColor(Color(hex: "#F7F2EC").opacity(0.3))
                }
                .padding(.horizontal, 32)

                Button(action: { showReview = true }) {
                    Text("Capture")
                        .font(.custom("Inter", size: 17, relativeTo: .body))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(themeManager.accentSafeColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)

                Button(action: { showReview = true }) {
                    Text("Skip this step")
                        .font(.custom("Inter", size: 15))
                        .foregroundColor(Color(hex: "#8B8290"))
                        .underline()
                }

                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showReview) {
            ReviewRetakeView()
        }
    }
}
