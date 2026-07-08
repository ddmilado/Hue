import SwiftUI

struct PermissionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showGalleryFallback = false
    @State private var showChecklist = false
    @StateObject private var cameraService = CameraService()

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "camera.fill")
                    .font(.system(size: 64))
                    .foregroundColor(Color(hex: "#C8A86E"))

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
                        .background(Color(hex: "#C8A86E"))
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)

                if showGalleryFallback {
                    Button(action: { showChecklist = true }) {
                        Text("Upload a photo instead")
                            .font(.custom("Inter", size: 15))
                            .foregroundColor(Color(hex: "#8B8290"))
                            .underline()
                    }
                }

                Button(action: { dismiss() }) {
                    Text("Not now")
                        .font(.custom("Inter", size: 15))
                        .foregroundColor(Color(hex: "#8B8290"))
                }
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showChecklist) {
            CapturePrepView()
        }
    }
}
