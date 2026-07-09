import SwiftUI
import PhotosUI

struct TryItOnView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var generationService = GenerationService.shared

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedPhoto: UIImage?
    @State private var selectedGarment = "Blouse"
    @State private var showGenerationLimit = false

    let garments = ["Blouse", "Dress", "Coat", "Top", "Jacket", "Sweater", "Skirt", "Pants"]

    private var canGenerate: Bool {
        selectedPhoto != nil && !generationService.isGenerating
    }

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView {
                    VStack(spacing: 20) {
                        photoSection
                        garmentPicker
                        generateButton
                        recentGenerations
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .onChange(of: selectedItem) { loadPhoto() }
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("Try It On")
                .font(.custom("Fraunces", size: 28))
                .foregroundColor(Color(hex: "#F7F2EC"))
                .padding(.top, 12)
            Text("Upload a photo and see outfits in your colors")
                .font(.custom("Inter", size: 13))
                .foregroundColor(Color(hex: "#8B8290"))
        }
        .padding(.bottom, 8)
    }

    private var photoSection: some View {
        VStack(spacing: 12) {
            if let photo = selectedPhoto {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(3/4, contentMode: .fit)
                        .frame(maxHeight: 280)
                        .cornerRadius(16)

                    Button(action: { selectedPhoto = nil; selectedItem = nil }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "#F7F2EC"))
                            .background(Circle().fill(Color.black.opacity(0.6)))
                    }
                    .padding(8)
                    .accessibilityLabel("Remove photo")
                }

                if let season = navigationState.latestResult?.season {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(themeManager.accentSafeColor)
                            .frame(width: 8, height: 8)
                        Text("Generating for \(season.rawValue) palette")
                            .font(.custom("Inter", size: 12))
                            .foregroundColor(Color(hex: "#8B8290"))
                    }
                }
            } else {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "#8B8290").opacity(0.3), style: SwiftUI.StrokeStyle(lineWidth: 1.5, dash: [8, 4]))
                            .frame(maxWidth: 280, minHeight: 200)

                        VStack(spacing: 12) {
                            Image(systemName: "plus.viewfinder")
                                .font(.system(size: 36))
                                .foregroundColor(Color(hex: "#8B8290"))
                            Text("Tap to upload a photo")
                                .font(.custom("Inter", size: 15))
                                .foregroundColor(Color(hex: "#8B8290"))
                            Text("Face-forward, good lighting")
                                .font(.custom("Inter", size: 12))
                                .foregroundColor(Color(hex: "#8B8290").opacity(0.6))
                        }
                    }
                }
                .accessibilityLabel("Upload photo")
            }
        }
        .padding(.horizontal, 24)
    }

    private var garmentPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Garment type")
                .font(.custom("Inter", size: 14))
                .foregroundColor(Color(hex: "#8B8290"))
                .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(garments, id: \.self) { garment in
                        Button(action: { selectedGarment = garment }) {
                            Text(garment)
                                .font(.custom("Inter", size: 14))
                                .foregroundColor(selectedGarment == garment ? .white : Color(hex: "#8B8290"))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 9)
                                .background(selectedGarment == garment ? themeManager.accentSafeColor : Color(hex: "#2A2729"))
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }

    private var generateButton: some View {
        Button(action: generate) {
            HStack(spacing: 10) {
                if generationService.isGenerating {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Generating...")
                } else {
                    Image(systemName: "sparkles")
                    Text("Generate Outfits")
                }
            }
            .font(.custom("Inter", size: 17, relativeTo: .body))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(canGenerate ? themeManager.accentSafeColor : Color(hex: "#8B8290").opacity(0.4))
            .cornerRadius(12)
        }
        .pressable()
        .disabled(!canGenerate)
        .padding(.horizontal, 24)
    }

    private var recentGenerations: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !generationService.savedLooks.isEmpty {
                HStack {
                    Text("Saved Looks")
                        .font(.custom("Fraunces", size: 20))
                        .foregroundColor(Color(hex: "#F7F2EC"))
                    Spacer()
                    Text("\(generationService.savedLooks.count)")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color(hex: "#8B8290"))
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(generationService.savedLooks) { look in
                        lookCard(look)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }

    private func lookCard(_ look: GeneratedLook) -> some View {
        ZStack(alignment: .topTrailing) {
            if let img = generationService.image(for: look) {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(3/4, contentMode: .fit)
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#2A2729"))
                    .aspectRatio(3/4, contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(Color(hex: "#8B8290"))
                    )
            }

            VStack(alignment: .trailing, spacing: 4) {
                Button(action: { generationService.deleteLook(look) }) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title3)
                        .foregroundColor(.red.opacity(0.8))
                        .background(Circle().fill(Color.black.opacity(0.5)))
                }
                .padding(6)
                .accessibilityLabel("Delete look")

                Spacer()

                Text(look.garmentType)
                    .font(.custom("Inter", size: 11))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(4)
                    .padding(6)
            }
        }
    }

    private func generate() {
        guard let photo = selectedPhoto,
              let season = navigationState.latestResult?.season else { return }

        Task {
            await generationService.generateOutfit(
                userPhoto: photo,
                garmentType: selectedGarment,
                season: season
            )
        }
    }

    private func loadPhoto() {
        guard let item = selectedItem else { return }
        Task {
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else { return }
            selectedPhoto = image
        }
    }
}
