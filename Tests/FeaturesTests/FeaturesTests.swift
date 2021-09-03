import XCTest
import Features

final class FeatureTests: XCTestCase {

    func test_nonExistingFeature_isDisabled() {
        let nonExistingFeature = "Any Feature"

        let isEnabled = Features.isEnabled(nonExistingFeature)

        XCTAssertFalse(isEnabled, "Expected \(nonExistingFeature) to be disabled. Got enabled.")
    }

    func test_nonExistingFeature_isEnableWithTrueDefaultValue() {
        let nonExistingFeature = "Any Feature"

        let isEnabled = Features.isEnabled(nonExistingFeature, default: true)

        XCTAssertTrue(isEnabled, "Expected \(nonExistingFeature) to be enabled. Got disabled.")

    }

    func test_nonExistingFeature_isDisableWithFalseDefaultValue() {
        let nonExistingFeature = "Any Feature"

        let isEnabled = Features.isEnabled(nonExistingFeature, default: false)

        XCTAssertFalse(isEnabled, "Expected \(nonExistingFeature) to be disabled. Got enabled.")
    }

    func test_featuresName_canBeAnEnumerationCase() {

        let isEnabled = Features.isEnabled(Features.Tests.test, default: true)
        XCTAssertTrue(isEnabled, "Expected `\(Features.Tests.test)` to be enabled. Got disabled.")
    }
}

private extension Features {
    enum Tests: String, FeatureName {
        var description: String { rawValue }

        case test
    }
}
