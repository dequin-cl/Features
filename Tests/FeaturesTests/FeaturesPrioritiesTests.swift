import XCTest
import Features

final class FeaturesPrioritiesTests: XCTestCase {
    private var primarySourceUserDefaults: UserDefaults!
    private var secondarySourceUserDefaults: UserDefaults!
    
    override func setUp() {
        primarySourceUserDefaults = UserDefaults(suiteName: userDefaultPrimarySuiteName())
        secondarySourceUserDefaults = UserDefaults(suiteName: userDefaultSecondarySuiteName())
    }
    
    override func tearDown() {
        primarySourceUserDefaults.removePersistentDomain(forName: userDefaultPrimarySuiteName())
        secondarySourceUserDefaults.removePersistentDomain(forName: userDefaultSecondarySuiteName())
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: #file, relativeTo: directoryURL).appendingPathExtension("plist")
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    func test_Features_returnsValueFromPrimarySource() {
        primarySourceUserDefaults.setValue(false, forKey: "Test")
        secondarySourceUserDefaults.setValue(true, forKey: "Test")
        
        let isEnabled = Features.isEnabled("Test")
        
        XCTAssertFalse(isEnabled, "Expected `Test` to be disabled, got enabled")
    }
    
    // MARK: - Helpers
    private func userDefaultPrimarySuiteName() -> String { Features.TestHooks.primarySuiteName }
    private func userDefaultSecondarySuiteName() -> String { Features.TestHooks.secondarySuiteName }

}
