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
        let featureNames = ["featureName1", "featureName2", "featureName3"]
        featureNames.forEach { FeatureStore.set(true, for: $0, on: .primary) }
        
        FeatureStore.remove(feature: "featureName1",from: .primary)

        let expectedFeatureNames = ["featureName2", "featureName3"]
        
        let isEnabled = Features.TestHooksSource.isEnabledInPrimary("featureName1")
        XCTAssertNil(isEnabled, "Expected `featureName1` to not be defined on Primary source")
        
        let isEnabledInPrimary: [FeaturesState] = expectedFeatureNames.map { ($0, Features.TestHooksSource.isEnabledInPrimary($0)) }
        isEnabledInPrimary.forEach { isEnabled in
            XCTAssertEqual(isEnabled.isEnabled, true, "Expected `\(isEnabled.feature)` to be defined on Primary source")
        }
    }
}
