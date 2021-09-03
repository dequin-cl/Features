import Foundation

public protocol FeatureName: CustomStringConvertible {}

extension UserDefaults {
    private static let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    
    static var local: UserDefaults {
        return UserDefaults(suiteName: "\(bundleIdentifier).local")!
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
