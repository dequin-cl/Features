import Foundation

public enum FeatureSource {
    case primary
    case secondary
}

public enum FeatureStore {

    public static func set(_ value: Bool, for name: FeatureName, on featureSource: FeatureSource) {
        set(value, for: name.description, on: featureSource)
    }

    public static func set(_ value: Bool, for name: String, on featureSource: FeatureSource) {
        source(featureSource).object?.setValue(value, forKey: name)
    }

    public static func removeAll(from featureSource: FeatureSource) {
        source(featureSource).object?.removePersistentDomain(forName: source(featureSource).name)
    }

    public static func remove(feature name: FeatureName, from featureSource: FeatureSource) {
        remove(feature: name.description, from: featureSource)
    }

    public static func remove(feature key: String, from featureSource: FeatureSource) {
        source(featureSource).object?.removeObject(forKey: key)
    }

    private static func source(_ source: FeatureSource) -> (object: UserDefaults?, name: String) {
        switch source {
        case .primary:
            return (UserDefaults.primary, UserDefaults.primarySourceName)
        case .secondary:
            return (UserDefaults.secondary, UserDefaults.secondarySourceName)
        }

    }
}
