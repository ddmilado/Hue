import Foundation

enum Config {
    static let supabaseURL: URL = {
        guard let string = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let url = URL(string: string),
              url.host != "your-project.supabase.co" else {
            return URL(string: "https://placeholder.supabase.co")!
        }
        return url
    }()

    static let supabaseAnonKey: String = {
        guard let key = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String,
              key != "your-anon-key-here" else {
            return "placeholder-key"
        }
        return key
    }()

    static var isSupabaseConfigured: Bool {
        supabaseURL.host != "placeholder.supabase.co" &&
        supabaseAnonKey != "placeholder-key"
    }

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
