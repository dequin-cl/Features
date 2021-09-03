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
        
        FeatureStore.set(true, for: "featureName1", on: .primary)
        FeatureStore.set(true, for: "featureName2", on: .primary)
        FeatureStore.set(true, for: "featureName3", on: .primary)
        
        FeatureStore.removeAll(from: .primary)
        
        let isEnabledInPrimary1 = Features.TestHooksSource.isEnabledInPrimary("featureName1")
        let isEnabledInPrimary2 = Features.TestHooksSource.isEnabledInPrimary("featureName2")
        let isEnabledInPrimary3 = Features.TestHooksSource.isEnabledInPrimary("featureName3")

        XCTAssertNil(isEnabledInPrimary1, "Expected `featureName1` to not be defined on Primary source")
        XCTAssertNil(isEnabledInPrimary2, "Expected `featureName2` to not be defined on Primary source")
        XCTAssertNil(isEnabledInPrimary3, "Expected `featureName3` to not be defined on Primary source")

    }    
}

