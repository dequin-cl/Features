import Foundation

public protocol FeatureName: CustomStringConvertible {}

fileprivate enum Configuration {
    static let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    static let localSuiteName = "\(bundleIdentifier).local"
    static let remoteSuiteName = "\(bundleIdentifier).remote"
}

private extension UserDefaults {
    static var local: UserDefaults { UserDefaults(suiteName: Configuration.localSuiteName)! }
}

public enum Features {

    public static func isEnabled(_ name: FeatureName, default: Bool = false) -> Bool {
        isEnabled(name.description,default: `default`)
    }
    
    public static func isEnabled(_ name: String, default: Bool = false) -> Bool {
        FeaturesValue.isEnabled(name) ?? `default`
    }
}

private struct FeaturesValue {
    static func isEnabled(_ name: String, source: UserDefaults = .local) -> Bool? {
        source.object(forKey: name) as? Bool
    }
}

// MARK: - TestHooks

#if DEBUG
    public extension Features {
        struct TestHooks {
            public static var primarySuiteName: String { Configuration.localSuiteName }
            public static var secondarySuiteName: String { Configuration.remoteSuiteName }
        }
    }
#endif
