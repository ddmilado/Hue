import Foundation

enum Config {
    static let supabaseURL: URL = {
        guard let string = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let url = URL(string: string) else {
            fatalError("SUPABASE_URL not configured in Info.plist")
        }
        return url
    }()

    static let supabaseAnonKey: String = {
        guard let key = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String else {
            fatalError("SUPABASE_ANON_KEY not configured in Info.plist")
        }
        return key
    }()

    static let amplitudeAPIKey: String = {
        Bundle.main.infoDictionary?["AMPLITUDE_API_KEY"] as? String ?? ""
    }()

    static let sentryDSN: String = {
        Bundle.main.infoDictionary?["SENTRY_DSN"] as? String ?? ""
    }()

    static let appStoreSharedSecret: String = {
        Bundle.main.infoDictionary?["APP_STORE_SHARED_SECRET"] as? String ?? ""
    }()
}
