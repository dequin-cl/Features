import Foundation

fileprivate enum Configuration {
    static let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    static let localSuiteName = "\(bundleIdentifier).local"
    static let remoteSuiteName = "\(bundleIdentifier).remote"
}

extension UserDefaults {
    static var secondary: UserDefaults { UserDefaults(suiteName: Configuration.localSuiteName)! }
    static var primary: UserDefaults { UserDefaults(suiteName: Configuration.remoteSuiteName)! }
    
    static var primarySourceName: String { Configuration.remoteSuiteName }
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
