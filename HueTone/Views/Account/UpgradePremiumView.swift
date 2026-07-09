import SwiftUI
import StoreKit

struct UpgradePremiumView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var authService: AuthService
    @State private var isPurchasing = false
    @State private var showThankYou = false
    @State private var selectedProduct: Product?
    @State private var products: [Product] = []
    @State private var isMonthly = true

    var body: some View {
        ZStack {
            Color(hex: "#1C1B1F").ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Image(systemName: "crown.fill")
                    .font(.system(size: 56))
                    .foregroundColor(themeManager.accentSafeColor)

                Text("Upgrade to Premium")
                    .font(.custom("Fraunces", size: 32))
                    .foregroundColor(Color(hex: "#F7F2EC"))
                    .accessibilityLabel("Upgrade to premium")

                VStack(alignment: .leading, spacing: 16) {
                    PremiumFeatureRow(icon: "infinity", text: "Unlimited Try It On generations",
                                    themeManager: themeManager)
                    PremiumFeatureRow(icon: "sparkles.rectangle.stack", text: "Pattern Studio access",
                                    themeManager: themeManager)
                    PremiumFeatureRow(icon: "camera.viewfinder", text: "Shopping Mode",
                                    themeManager: themeManager)
                    PremiumFeatureRow(icon: "star.fill", text: "Priority curated picks",
                                    themeManager: themeManager)
                }
                .padding(.horizontal, 32)

                if !products.isEmpty {
                    Picker("Billing", selection: $isMonthly) {
                        Text("Monthly").tag(true)
                        Text("Yearly").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 40)
                    .onChange(of: isMonthly) { updateSelectedProduct() }

                    Text(productPrice)
                        .font(.custom("Inter", size: 16, relativeTo: .body))
                        .foregroundColor(Color(hex: "#8B8290"))
                }

                Button(action: subscribe) {
                    if isPurchasing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Subscribe")
                            .font(.custom("Inter", size: 17, relativeTo: .body))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(themeManager.accentSafeColor)
                            .cornerRadius(12)
                    }
                }
                .pressable()
                .padding(.horizontal, 40)
                .disabled(isPurchasing || products.isEmpty)
                .accessibilityLabel("Subscribe to premium")

                Button(action: { dismiss() }) {
                    Text("Maybe later")
                        .font(.custom("Inter", size: 15))
                        .foregroundColor(Color(hex: "#8B8290"))
                }
                .accessibilityLabel("Maybe later")

                Spacer()
            }
        }
        .alert("Thank You!", isPresented: $showThankYou) {
            Button("OK", role: .cancel) { dismiss() }
        } message: {
            Text("You've been upgraded to Premium. Enjoy all the features!")
        }
        .task {
            await loadProducts()
        }
    }

    private var productPrice: String {
        guard let product = selectedProduct else { return "" }
        return product.displayPrice + (isMonthly ? "/month" : "/year")
    }

    private func loadProducts() async {
        do {
            products = try await Product.products(for: ProductID.all)
            updateSelectedProduct()
        } catch {
            products = []
        }
    }

    private func updateSelectedProduct() {
        let id = isMonthly ? ProductID.premiumMonthly : ProductID.premiumYearly
        selectedProduct = products.first { $0.id == id }
    }

    private func subscribe() {
        guard let product = selectedProduct else { return }
        isPurchasing = true
        Task {
            defer { isPurchasing = false }
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        await validateReceipt(transaction: transaction)
                        await transaction.finish()
                        showThankYou = true
                    case .unverified:
                        alertMessage = "Receipt verification failed."
                        showAlert = true
                    }
                case .pending:
                    break
                case .userCancelled:
                    break
                @unknown default:
                    break
                }
            } catch {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }

    private func validateReceipt(transaction: StoreKit.Transaction) async {
        guard Config.isSupabaseConfigured,
              let receiptData = receiptDataString,
              authService.isAuthenticated else { return }

        let url = Config.supabaseURL.appendingPathComponent("/functions/v1/validate-receipt")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.supabaseAnonKey, forHTTPHeaderField: "apikey")

        let body = [
            "receiptData": receiptData,
            "userId": authService.currentUser?.id.uuidString ?? "",
            "productId": transaction.productID
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                await authService.refreshSubscriptionStatus()
            }
        } catch {
            // Receipt will be validated on next sync
        }
    }

    private var receiptDataString: String? {
        guard let url = Bundle.main.appStoreReceiptURL,
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return data.base64EncodedString()
    }

    @State private var showAlert = false
    @State private var alertMessage = ""
}

struct PremiumFeatureRow: View {
    let icon: String
    let text: String
    let themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(themeManager.accentSafeColor)
                .frame(width: 24)
            Text(text)
                .font(.custom("Inter", size: 15))
                .foregroundColor(Color(hex: "#F7F2EC"))
        }
    }
}
