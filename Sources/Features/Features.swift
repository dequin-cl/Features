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

    static private let composer = FeaturesComposer(primary: FeaturesValue(source: UserDefaults.local), secondary: FeaturesValue(source: UserDefaults.remote))
    
    public static func isEnabled(_ name: FeatureName, default: Bool = false) -> Bool {
        isEnabled(name.description,default: `default`)
    }
    
    public static func isEnabled(_ name: String, default: Bool = false) -> Bool {
        composer.isEnabled(name, default: `default`)
    }
}

protocol FeaturesProvider {
    func isEnabled(_ name: String, default: Bool) -> Bool
}

protocol FeaturesValueProvider {
    func isEnabled(_ name: String) -> Bool?
}

struct FeaturesComposer: FeaturesProvider {
    let primary: FeaturesValueProvider
    let secondary: FeaturesValueProvider
    
    init(primary: FeaturesValueProvider, secondary: FeaturesValueProvider) {
        self.primary = primary
        self.secondary = secondary
    }

    func isEnabled(_ name: String, default: Bool) -> Bool {
        process(primary.isEnabled(name), secondary.isEnabled(name), default: `default`)
    }
    
    private func process(_ primary: Bool?, _ secondary: Bool?, default: Bool) -> Bool {
        if let primary = primary {
            return primary
        }

        if let secondary = secondary {
            return secondary
        }

        return `default`
    }
}

struct FeaturesValue: FeaturesValueProvider {
    
    private let source: UserDefaults
    
    init(source: UserDefaults) {
        self.source = source
    }
    
    func isEnabled(_ name: String) -> Bool? {
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
