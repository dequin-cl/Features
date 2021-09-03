import XCTest
import Features

final class FeaturesIntegratedTests: XCTestCase {
    private var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: userDefaultLocalSuiteName())
    }

    override func tearDown() {
        super.tearDown()
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

    func test_featureIsDisable_forFalseValueInUserDefault() {
        userDefaults.setValue(false, forKey: "Test")

        let isEnabled = Features.isEnabled("Test")

        XCTAssertFalse(isEnabled, "Expected `Test` to be disabled, got enabled")
    }

    func test_featureName_IsEnable_forTrueValueInUserDefault() {
        userDefaults.setValue(true, forKey: Features.Tests.test.rawValue)

        let isEnabled = Features.isEnabled(Features.Tests.test)

        XCTAssertTrue(isEnabled, "Expected `Test` to be enabled, got disabled")
    }

    func test_featureName_IsDisable_forFalseValueInUserDefault() {
        userDefaults.setValue(false, forKey: Features.Tests.test.rawValue)

        let isEnabled = Features.isEnabled(Features.Tests.test)

        XCTAssertFalse(isEnabled, "Expected `Test` to be disabled, got enabled")
    }

    // MARK: - Helpers
    private func userDefaultLocalSuiteName() -> String { Features.TestHooks.primarySuiteName }
}

private extension Features {
    enum Tests: String, FeatureName {
        var description: String { rawValue }

        case test
    }
}
