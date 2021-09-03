import Foundation

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
