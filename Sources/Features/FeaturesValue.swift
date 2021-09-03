import Foundation

struct FeaturesValue: FeaturesValueProvider {

    private let source: UserDefaults?

    init(source: UserDefaults?) {
        self.source = source
    }

    func isEnabled(_ name: String) -> Bool? {
        source?.object(forKey: name) as? Bool
    }
}
