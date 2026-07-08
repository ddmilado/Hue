import SwiftUI

struct PermissionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showGalleryFallback = false
    @State private var showChecklist = false
    @StateObject private var cameraService = CameraService()
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "camera.fill")
                    .font(.system(size: 64))
                    .foregroundColor(themeManager.accentSafeColor)

                Text("Camera Access")
                    .font(.custom("Fraunces", size: 28))
                    .foregroundColor(Color(hex: "#F7F2EC"))

                Text("We need your camera to analyze your coloring.\nPhotos stay on your device unless you choose\nto save your result.")
                    .font(.custom("Inter", size: 15))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .multilineTextAlignment(.center)

                Spacer()

                Button(action: {
                    Task {
                        let authorized = await cameraService.requestPermission()
                        if authorized {
                            showChecklist = true
                        } else {
                            showGalleryFallback = true
                        }
                    }
                }) {
                    Text("Allow Camera Access")
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
                .accessibilityLabel("Allow camera access")

                if showGalleryFallback {
                    Button(action: { showChecklist = true }) {
                        Text("Upload a photo instead")
                            .font(.custom("Inter", size: 15))
                            .foregroundColor(Color(hex: "#8B8290"))
                            .underline()
                    }
                    .accessibilityLabel("Upload a photo instead")
                }

                Button(action: { dismiss() }) {
                    Text("Not now")
                        .font(.custom("Inter", size: 15))
                        .foregroundColor(Color(hex: "#8B8290"))
                }
                .padding(.bottom, 40)
                .accessibilityLabel("Not now")
            }
        }
        .fullScreenCover(isPresented: $showChecklist) {
            CapturePrepView()
        }
    }
}
