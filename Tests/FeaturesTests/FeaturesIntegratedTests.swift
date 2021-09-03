import XCTest
import Features

final class FeaturesIntegratedTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    
    override func setUp() {
        userDefaults = UserDefaults(suiteName: userDefaultSuiteName())
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: userDefaultSuiteName())
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: #file, relativeTo: directoryURL).appendingPathExtension("plist")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    func test_featureIsEnable_forTrueValueInUserDefault() {
        userDefaults.setValue(true, forKey: "Test")
        
        let isEnabled = Features.isEnabled("Test")
        
        XCTAssertTrue(isEnabled, "Expected `Test` to be enabled, got disabled")
    }
    
    // MARK: - Helpers
    private func userDefaultSuiteName() -> String {
        "\(bundleIdentifier).local"
    }
}
