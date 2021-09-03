import Foundation

public enum FeatureSource {
    case primary
    case secondary
}

public enum FeatureStore {
    
    public static func set(_ value: Bool, for name: String, on source: FeatureSource) {
        switch source {
        case .primary:
            UserDefaults.primary.setValue(value, forKey: name)
        case .secondary:
            UserDefaults.secondary.setValue(value, forKey: name)
        }
    }
    
    public static func removeAll(from source: FeatureSource) {
        UserDefaults.primary.removePersistentDomain(forName: UserDefaults.primarySourceName)
    }
    
    public static func remove(feature key: String, from source: FeatureSource) {
        UserDefaults.primary.removeObject(forKey: key)
    }
}
