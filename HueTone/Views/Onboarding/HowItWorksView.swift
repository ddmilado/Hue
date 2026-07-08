import SwiftUI

struct HowItWorksView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPermissions = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                Text("How It Works")
                    .font(.custom("Fraunces", size: 32))
                    .foregroundColor(Color(hex: "#F7F2EC"))

                VStack(alignment: .leading, spacing: 32) {
                    StepView(number: 1, title: "Snap a bare-faced photo in natural light.",
                             icon: "camera.aperture")
                    StepView(number: 2, title: "We read your depth, undertone, and contrast.",
                             icon: "eyedropper.halffull")
                    StepView(number: 3, title: "Get your season and a palette built for you.",
                             icon: "palette")
                }
                .padding(.horizontal, 32)

                Spacer()

                Button(action: { showPermissions = true }) {
                    Text("Get Started")
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(hex: "#F7F2EC"))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showPermissions) {
            PermissionView()
        }
    }
}

struct StepView: View {
    let number: Int
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: "#C8A86E"))
                .frame(width: 40)

            Text(title)
                .font(.custom("Inter", size: 16))
                .foregroundColor(Color(hex: "#F7F2EC"))
        }
    }
}
