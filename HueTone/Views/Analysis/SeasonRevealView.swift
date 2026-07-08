import SwiftUI

struct SeasonRevealView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var navigationState: NavigationState
    @State private var showDeepDive = false
    @State private var showWallet = false
    @State private var fanResolved = false

    @State private var seasonNameScale: CGFloat = 0.5
    @State private var seasonNameOpacity: Double = 0
    @State private var confidenceOpacity: Double = 0
    @State private var descriptionOpacity: Double = 0
    @State private var buttonsOffset: CGFloat = 50
    @State private var buttonsOpacity: Double = 0
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            if showConfetti {
                ConfettiView()
            }

            VStack(spacing: 16) {
                Spacer()

                ColorFanReveal(swatches: [], isBlurred: false)
                    .frame(height: 200)
                    .padding(.top, 40)

                Text(navigationState.latestResult?.season.rawValue ?? "Deep Autumn")
                    .font(.custom("Fraunces", size: 34))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .scaleEffect(seasonNameScale)
                    .opacity(seasonNameOpacity)
                    .accessibilityLabel("Your season is \(navigationState.latestResult?.season.rawValue ?? "Deep Autumn")")

                HStack(spacing: 8) {
                    Circle()
                        .fill(themeManager.accentSafeColor)
                        .frame(width: 8, height: 8)
                    Text("\(Int((navigationState.latestResult?.confidence ?? 0.92) * 100))% confidence")
                        .font(.custom("Inter", size: 14))
                        .foregroundColor(themeManager.accentSafeColor)
                }
                .opacity(confidenceOpacity)

                let season = navigationState.latestResult?.season ?? .deepAutumn
                Text(SeasonTaxonomy.description(for: season))
                    .font(.custom("Inter", size: 14))
                    .foregroundColor(Color(hex: "#8B8290"))
                    .multilineTextAlignment(.center)
                    .opacity(descriptionOpacity)

                Spacer()

                HStack(spacing: 12) {
                    Button(action: { showDeepDive = true }) {
                        Text("Learn More")
                            .font(.custom("Inter", size: 15))
                            .foregroundColor(Color(hex: "#F7F2EC"))
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#2A2729"))
                            .cornerRadius(12)
                    }
                    .pressable()
                    .opacity(buttonsOpacity)
                    .offset(y: buttonsOffset)

                    Button(action: {
                        showWallet = true
                        navigationState.hasCompletedOnboarding = true
                        navigationState.currentAnalysisState = .completed
                    }) {
                        Text("My Wallet")
                            .font(.custom("Inter", size: 15))
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(themeManager.accentSafeColor)
                            .cornerRadius(12)
                    }
                    .pressable()
                    .opacity(buttonsOpacity)
                    .offset(y: buttonsOffset)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            themeManager.isPreReveal = false
            startRevealAnimation()
        }
        .fullScreenCover(isPresented: $showDeepDive) {
            SeasonDeepDiveView()
        }
        .fullScreenCover(isPresented: $showWallet) {
            MainTabView()
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
        }
    }

    private func startRevealAnimation() {
        withAnimation(.easeOut(duration: 1.2).delay(0.3)) {
            seasonNameScale = 1
            seasonNameOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.8).delay(1.0)) {
            confidenceOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.8).delay(1.4)) {
            descriptionOpacity = 1
        }
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.8)) {
            buttonsOpacity = 1
            buttonsOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.4)) {
                showConfetti = true
            }
        }
    }
}

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                generateParticles(in: geo.size)
            }
        }
        .allowsHitTesting(false)
    }

    private func generateParticles(in size: CGSize) {
        let colors: [Color] = [.gold, .orange, .yellow, .white, Color(hex: "#C8A86E")]
        particles = (0..<30).map { i in
            let x = CGFloat.random(in: 0...size.width)
            let endY = size.height + 50
            return ConfettiParticle(
                id: i,
                color: colors.randomElement()!,
                size: CGFloat.random(in: 4...10),
                position: CGPoint(x: x, y: -50),
                opacity: 1,
                endY: endY
            )
        }
        for index in particles.indices {
            let delay = Double.random(in: 0...1.0)
            let duration = Double.random(in: 2.0...3.5)
            withAnimation(.easeOut(duration: duration).delay(delay)) {
                particles[index].position.y = particles[index].endY
                particles[index].opacity = 0
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id: Int
    let color: Color
    let size: CGFloat
    var position: CGPoint
    var opacity: Double
    let endY: CGFloat
}

private extension Color {
    static let gold = Color(hex: "#FFD700")
}
