import Foundation

enum ProductID {
    static let premiumMonthly = "com.huetone.premium.monthly"
    static let premiumYearly = "com.huetone.premium.yearly"

    static var all: Set<String> {
        [premiumMonthly, premiumYearly]
    }
}
