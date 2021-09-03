import Foundation

public protocol FeatureName: CustomStringConvertible {}

public enum Features {

    private static let composer = FeaturesComposer(
        primary: FeaturesValue(source: UserDefaults.primary),
        secondary: FeaturesValue(source: UserDefaults.secondary)
    )

    public static func isEnabled(_ name: FeatureName, default: Bool = false) -> Bool {
        isEnabled(name.description, default: `default`)
    }

    public static func isEnabled(_ name: String, default: Bool = false) -> Bool {
        composer.isEnabled(name, default: `default`)
    }
}

// MARK: - TestHooks

#if DEBUG
    public extension Features {
        enum TestHooksSource {
            public static func isEnabledInPrimary(_ name: String) -> Bool? { UserDefaults.primary?.value(forKey: name) as? Bool }
            public static func isEnabledInSecondary(_ name: String) -> Bool? { UserDefaults.secondary?.value(forKey: name) as? Bool }
        }
    }
#endif
