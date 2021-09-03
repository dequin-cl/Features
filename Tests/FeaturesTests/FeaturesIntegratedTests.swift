import XCTest
import Features

final class FeaturesIntegratedTests: XCTestCase {
    private var userDefaults: UserDefaults!
    
    override func setUp() {
        userDefaults = UserDefaults(suiteName: userDefaultLocalSuiteName())
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: userDefaultLocalSuiteName())
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: #file, relativeTo: directoryURL).appendingPathExtension("plist")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    func test_featureIsEnable_forTrueValueInUserDefault() {
        userDefaults.setValue(true, forKey: "Test")
        
        let isEnabled = Features.isEnabled("Test")
        
        XCTAssertTrue(isEnabled, "Expected `Test` to be enabled, got disabled")
    }
    
    func test_featureName_IsEnable_forTrueValueInUserDefault() {
        userDefaults.setValue(true, forKey: Features.Tests.test.rawValue)
        
        let isEnabled = Features.isEnabled(Features.Tests.test)
        
        XCTAssertTrue(isEnabled, "Expected `Test` to be enabled, got disabled")
    }
    
    // MARK: - Helpers
    private func userDefaultLocalSuiteName() -> String { Features.TestHooks.localSuiteName }
}

private extension Features {
    enum Tests: String, FeatureName {
        var description: String { rawValue }
        
        case test
    }
}
