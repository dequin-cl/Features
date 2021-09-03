import Foundation

public protocol FeatureName: CustomStringConvertible {}

fileprivate enum Configuration {
    static let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    static let localSuiteName = "\(bundleIdentifier).local"
    static let remoteSuiteName = "\(bundleIdentifier).remote"
}

private extension UserDefaults {
    static var local: UserDefaults { UserDefaults(suiteName: Configuration.localSuiteName)! }
    static var remote: UserDefaults { UserDefaults(suiteName: Configuration.remoteSuiteName)! }
}

public enum Features {

    static private let composer = FeaturesComposer(
        primary: FeaturesValue(source: UserDefaults.remote),
        secondary: FeaturesValue(source: UserDefaults.local)
    )
    
    public static func isEnabled(_ name: FeatureName, default: Bool = false) -> Bool {
        isEnabled(name.description,default: `default`)
    }
    
    public static func isEnabled(_ name: String, default: Bool = false) -> Bool {
        composer.isEnabled(name, default: `default`)
    }
}

// MARK: - TestHooks

#if DEBUG
    public extension Features {
        struct TestHooks {
            public static var primarySuiteName: String { Configuration.remoteSuiteName }
            public static var secondarySuiteName: String { Configuration.localSuiteName }
        }
    }
#endif
