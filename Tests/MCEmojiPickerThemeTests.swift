import XCTest
@testable import MCEmojiPicker

@available(iOS 13.0, *)
class MCEmojiPickerThemeTests: XCTestCase {
    
    func testThemeUserInterfaceStyleMapping() {
        // Test automatic theme
        XCTAssertEqual(MCEmojiPickerTheme.automatic.userInterfaceStyle, .unspecified)
        
        // Test light theme
        XCTAssertEqual(MCEmojiPickerTheme.light.userInterfaceStyle, .light)
        
        // Test dark theme
        XCTAssertEqual(MCEmojiPickerTheme.dark.userInterfaceStyle, .dark)
    }
    
    func testViewControllerThemeApplication() {
        let viewController = MCEmojiPickerViewController()
        
        // Test setting light theme
        viewController.theme = .light
        XCTAssertEqual(viewController.overrideUserInterfaceStyle, .light)
        
        // Test setting dark theme
        viewController.theme = .dark
        XCTAssertEqual(viewController.overrideUserInterfaceStyle, .dark)
        
        // Test setting automatic theme
        viewController.theme = .automatic
        XCTAssertEqual(viewController.overrideUserInterfaceStyle, .unspecified)
    }
}
