import XCTest
import Features

enum Features {
    static func isEnabled(_ name: String) -> Bool {
        false
    }
}

final class FeatureTests: XCTestCase {

    func test_nonExistingFeature_isDisabled() {
        let nonExistingFeature = "Any Feature"
        let isEnabled = Features.isEnabled(nonExistingFeature)
        
        XCTAssertFalse(isEnabled, "Expected \(nonExistingFeature) to be disabled. Got enabled")
    }
}
