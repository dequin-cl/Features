import Foundation

public protocol FeatureName: CustomStringConvertible {}

fileprivate extension UserDefaults {
    static let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    static let localSuiteName = "\(bundleIdentifier).local"
    
    static var local: UserDefaults {
        return UserDefaults(suiteName: localSuiteName)!
    }
}

public enum Features {
    public static func isEnabled(_ name: String, default: Bool = false) -> Bool {
        UserDefaults.local.value(forKey: name) as? Bool ?? `default`
    }

    public static func isEnabled(_ name: FeatureName, default: Bool = false) -> Bool {
        UserDefaults.local.value(forKey: name.description) as? Bool ?? `default`
    }
}

// MARK: - TestHooks

#if DEBUG
    public extension Features {
        struct TestHooks {
            public static var localSuiteName: String { UserDefaults.localSuiteName }
        }
    }
#endif
