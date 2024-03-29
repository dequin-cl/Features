import XCTest
import Features

final class FeaturesStoreTests: XCTestCase {

    func test_featureValueCanBeSaved_onPrimary() {
        let featureName = "OnPrimary"
        FeatureStore.set(true, for: featureName, on: .primary)

        let isEnabled = Features.isEnabled(featureName)
        let isEnabledInSecondary = Features.TestHooksSource.isEnabledInSecondary(featureName)

        XCTAssertTrue(isEnabled, "Expected `\(featureName)` to be enabled, got disabled")
        XCTAssertNil(isEnabledInSecondary, "Expected `\(featureName)` to not be defined on Secondary source")
    }

    func test_featureValueCanBeSaved_onSecondary() {
        let featureName = "OnSecondary"
        FeatureStore.set(true, for: featureName, on: .secondary)

        let isEnabled = Features.isEnabled(featureName)
        let isEnabledInPrimary = Features.TestHooksSource.isEnabledInPrimary(featureName)
        let isEnabledInSecondary = Features.TestHooksSource.isEnabledInSecondary(featureName)

        XCTAssertTrue(isEnabled, "Expected `\(featureName)` to be enabled, got disabled")
        XCTAssertEqual(isEnabledInSecondary, true, "Expected `\(featureName)` to be enabled in Secondary source, got disabled")
        XCTAssertNil(isEnabledInPrimary, "Expected `\(featureName)` to not be defined on Primary source")
    }

    func test_FeatureStore_canRemoveAllValues_fromPrimary() {
        typealias FeaturesState = (feature: String, isEnabled: Bool?)
        let featureNames = ["featureName1", "featureName2", "featureName3"]
        featureNames.forEach { FeatureStore.set(true, for: $0, on: .primary) }

        FeatureStore.removeAll(from: .primary)

        let isEnabledInPrimary: [FeaturesState] = featureNames.map { ($0, Features.TestHooksSource.isEnabledInPrimary($0)) }

        isEnabledInPrimary.forEach { isEnabled in
            XCTAssertNil(isEnabled.isEnabled, "Expected `\(isEnabled.feature)` to not be defined on Primary source")
        }
    }

    func test_FeatureStore_canRemoveOneValue_fromPrimary() {
        typealias FeaturesState = (feature: String, isEnabled: Bool?)
        let featureNames = [Features.Tests.featureName1, Features.Tests.featureName2, Features.Tests.featureName3]
        featureNames.forEach { FeatureStore.set(true, for: $0, on: .primary) }

        FeatureStore.remove(feature: Features.Tests.featureName1, from: .primary)

        let expectedFeatureNames = [Features.Tests.featureName2, Features.Tests.featureName3]

        let isEnabled = Features.TestHooksSource.isEnabledInPrimary("featureName1")
        XCTAssertNil(isEnabled, "Expected `featureName1` to not be defined on Primary source")

        let isEnabledInPrimary: [FeaturesState] = expectedFeatureNames.map {
            ($0.description, Features.TestHooksSource.isEnabledInPrimary($0.description))
        }
        isEnabledInPrimary.forEach { isEnabled in
            XCTAssertEqual(isEnabled.isEnabled, true, "Expected `\(isEnabled.feature)` to be defined on Primary source")
        }
    }

    func test_FeatureStore_canRemoveOneValue_fromPrimary_UsingFeatureName() {
        typealias FeaturesState = (feature: String, isEnabled: Bool?)
        let featureNames = ["featureName1", "featureName2", "featureName3"]
        featureNames.forEach { FeatureStore.set(true, for: $0, on: .primary) }

        FeatureStore.remove(feature: "featureName1", from: .primary)

        let expectedFeatureNames = ["featureName2", "featureName3"]

        let isEnabled = Features.TestHooksSource.isEnabledInPrimary("featureName1")
        XCTAssertNil(isEnabled, "Expected `featureName1` to not be defined on Primary source")

        let isEnabledInPrimary: [FeaturesState] = expectedFeatureNames.map { ($0, Features.TestHooksSource.isEnabledInPrimary($0)) }
        isEnabledInPrimary.forEach { isEnabled in
            XCTAssertEqual(isEnabled.isEnabled, true, "Expected `\(isEnabled.feature)` to be defined on Primary source")
        }
    }

    func test_FeatureStore_canRemoveAllValues_fromSecondary() {
        typealias FeaturesState = (feature: String, isEnabled: Bool?)
        let featureNames = ["featureName1", "featureName2", "featureName3"]
        featureNames.forEach { FeatureStore.set(true, for: $0, on: .secondary) }

        FeatureStore.removeAll(from: .secondary)

        let isEnabledInSecondary: [FeaturesState] = featureNames.map { ($0, Features.TestHooksSource.isEnabledInSecondary($0)) }

        isEnabledInSecondary.forEach { isEnabled in
            XCTAssertNil(isEnabled.isEnabled, "Expected `\(isEnabled.feature)` to not be defined on Secondary source")
        }
    }

    func test_FeatureStore_canRemoveOneValue_fromSecondary() {
        typealias FeaturesState = (feature: String, isEnabled: Bool?)
        let featureNames = ["featureName1", "featureName2", "featureName3"]
        featureNames.forEach { FeatureStore.set(true, for: $0, on: .secondary) }

        FeatureStore.remove(feature: "featureName1", from: .secondary)

        let expectedFeatureNames = ["featureName2", "featureName3"]

        let isEnabled = Features.TestHooksSource.isEnabledInSecondary("featureName1")
        XCTAssertNil(isEnabled, "Expected `featureName1` to not be defined on Secondary source")

        let isEnabledInSecondary: [FeaturesState] = expectedFeatureNames.map { ($0, Features.TestHooksSource.isEnabledInSecondary($0)) }
        isEnabledInSecondary.forEach { isEnabled in
            XCTAssertEqual(isEnabled.isEnabled, true, "Expected `\(isEnabled.feature)` to be defined on Secondary source")
        }
    }
}

private extension Features {
    enum Tests: String, FeatureName {
        var description: String { rawValue }

        case featureName1
        case featureName2
        case featureName3
    }
}
