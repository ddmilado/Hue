import Foundation

struct AppUser: Codable, Identifiable {
    let id: UUID
    var email: String
    var createdAt: Date
    var subscriptionTier: SubscriptionTier

    init(id: UUID = UUID(), email: String, createdAt: Date = Date(), subscriptionTier: SubscriptionTier = .free) {
        self.id = id
        self.email = email
        self.createdAt = createdAt
        self.subscriptionTier = subscriptionTier
    }
}

enum SubscriptionTier: String, Codable {
    case free
    case premium
}
