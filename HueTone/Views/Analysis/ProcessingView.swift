import SwiftUI

struct ProcessingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showTeaser = false
    @State private var currentLabel: String = "Depth"
    @State private var labelOpacity: Double = 1
    @State private var labelScale: CGFloat = 0.8
    @State private var processingError = false
    @State private var pulseScale: CGFloat = 1
    @State private var completionProgress: Double = 0
    @State private var showCompletionFlash = false
    @EnvironmentObject var navigationState: NavigationState
    @EnvironmentObject var themeManager: ThemeManager

    let labels = ["Depth", "Value", "Chroma", "Undertone", "Contrast"]

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            KaleidoscopeView(speed: 4)
                .opacity(0.3)

            if showCompletionFlash {
                Color(hex: themeManager.signatureAccentSafe)
                    .opacity(0.15)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            VStack(spacing: 32) {
                Spacer()

                if processingError {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.orange)
                        .transition(.scale.combined(with: .opacity))
                    Text("Analysis encountered an issue")
                        .font(.custom("Fraunces", size: 24))
                        .foregroundColor(Color(hex: "#F7F2EC"))
                    Text("Please try again with better lighting.")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color(hex: "#8B8290"))
                } else {
                    Text("Reading your undertones")
                        .font(.custom("Fraunces", size: 28))
                        .foregroundColor(Color(hex: "#F7F2EC"))
                        .transition(.opacity)

                    Text(currentLabel)
                        .font(.custom("Fraunces", size: 48))
                        .foregroundColor(themeManager.accentSafeColor)
                        .opacity(labelOpacity)
                        .scaleEffect(labelScale)

                    if showTeaser == false {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: themeManager.accentSafeColor))
                            .scaleEffect(1.5 * pulseScale)
                            .animation(
                                .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                                value: pulseScale
                            )
                    }

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 200, height: 4)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(themeManager.accentSafeColor)
                            .frame(width: 200 * completionProgress, height: 4)
                            .animation(.easeOut(duration: 0.5), value: completionProgress)
                    }

                    Spacer()

                    Text("Still working — this can take a moment")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(Color(hex: "#8B8290"))
                        .opacity(0.6)
                        .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            startPulse()
            runAnalysis()
        }
        .fullScreenCover(isPresented: $showTeaser) {
            TeaserRevealView()
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
        }
    }

    private func startPulse() {
        pulseScale = 1.1
    }

    private func runAnalysis() {
        let sampler = RegionSampler()
        let extractor = FeatureExtractor()
        let classifier = RuleBasedClassifier()

        let sampled = sampler.sampleRegions(from: UIImage(), regions: FaceRegion(
            cheek: .zero, forehead: .zero, jaw: .zero,
            underEye: .zero, hairRegion: .zero, irisRegion: .zero
        ))
        let features = extractor.extract(from: sampled)
        let result = classifier.classify(features: features)

        navigationState.latestResult = result
        navigationState.saveCurrentResultToHistory()

        var index = 0
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.25)) {
                labelOpacity = 0
                labelScale = 0.8
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                currentLabel = labels[index]
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    labelOpacity = 1
                    labelScale = 1
                }
                withAnimation(.easeOut(duration: 0.5)) {
                    completionProgress = Double(index + 1) / Double(labels.count)
                }
                index += 1
                if index >= labels.count {
                    timer.invalidate()
                    withAnimation(.easeOut(duration: 0.3)) {
                        showCompletionFlash = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        showTeaser = true
                    }
                }
            }
        }
    }
}
