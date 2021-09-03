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

}

