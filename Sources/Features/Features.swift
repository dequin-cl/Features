import Foundation

public protocol FeatureName: CustomStringConvertible {}

public enum Features {
    public static func isEnabled(_ name: String, default: Bool = false) -> Bool {
        `default`
    }

    public static func isEnabled(_ name: FeatureName, default: Bool = false) -> Bool {
        `default`
    }
}
