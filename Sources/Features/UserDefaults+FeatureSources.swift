import Foundation

private enum Configuration {
    // CFBundleIdentifier is a required String per Apple documentation
    // https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleidentifier
    // swiftlint:disable:next force_cast
    static let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    static let localSuiteName = "\(bundleIdentifier).local"
    static let remoteSuiteName = "\(bundleIdentifier).remote"
}

extension UserDefaults {
    static var secondary: UserDefaults? { UserDefaults(suiteName: Configuration.localSuiteName) }
    static var primary: UserDefaults? { UserDefaults(suiteName: Configuration.remoteSuiteName) }

    static var primarySourceName: String { Configuration.remoteSuiteName }
    static var secondarySourceName: String { Configuration.localSuiteName }
}

// MARK: - TestHooks

#if DEBUG
    public extension Features {
        enum TestHooks {
            public static var primarySuiteName: String { Configuration.remoteSuiteName }
            public static var secondarySuiteName: String { Configuration.localSuiteName }
        }
    }
#endif
