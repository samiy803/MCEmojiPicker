import UIKit

/// Theme options for MCEmojiPicker.
public enum MCEmojiPickerTheme {
    /// Automatically adjusts to the system's current appearance (light or dark mode).
    case automatic
    /// Forces the emoji picker to use light appearance.
    case light
    /// Forces the emoji picker to use dark appearance.
    case dark
    
    /// Converts the theme to the corresponding UIUserInterfaceStyle.
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .automatic:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
