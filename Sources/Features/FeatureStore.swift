import Foundation

public enum FeatureSource {
    case primary
    case secondary
}

public enum FeatureStore {
    
    public static func set(_ value: Bool, for name: String, on featureSource: FeatureSource) {
        source(featureSource).setValue(value, forKey: name)
    }
    
    public static func removeAll(from featureSource: FeatureSource) {
        source(featureSource).removePersistentDomain(forName: sourceName(featureSource))
    }
    
    public static func remove(feature key: String, from source: FeatureSource) {
        UserDefaults.primary.removeObject(forKey: key)
    }
    
    private static func source(_ source: FeatureSource) -> UserDefaults {
        switch source {
        case .primary:
            return UserDefaults.primary
        case .secondary:
            return UserDefaults.secondary
        }
    }
    
    private static func sourceName(_ source: FeatureSource) -> String {
        switch source {
        case .primary:
            return UserDefaults.primarySourceName
        case .secondary:
            return UserDefaults.secondarySourceName
        }
    }
}
