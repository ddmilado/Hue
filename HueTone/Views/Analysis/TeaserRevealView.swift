import SwiftUI

struct TeaserRevealView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showAccount = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ColorFanReveal(swatches: [], isBlurred: true)

                Text("Your results are ready.")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .padding(.top, 20)

                Text("Your season: — — — —")
                    .font(.custom("Fraunces", size: 20))
                    .foregroundColor(Color(hex: "#8B8290"))

                Spacer()

                VStack(spacing: 12) {
                    Text("We've found your season. Create an account\nto see your full palette and save your results.")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color(hex: "#8B8290"))
                        .multilineTextAlignment(.center)

                    Button(action: { showAccount = true }) {
                        Text("See Your Results")
                            .font(.custom("Inter", size: 17, relativeTo: .body))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "#C8A86E"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                }

                Button(action: { dismiss() }) {
                    Text("Not now")
                        .font(.custom("Inter", size: 15))
                        .foregroundColor(Color(hex: "#8B8290"))
                }
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showAccount) {
            CreateAccountView()
        }
    }
}
