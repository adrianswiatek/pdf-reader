import SwiftUI

extension Settings.Theme {
    func toColorScheme() -> ColorScheme? {
        switch self {
        case .auto: return nil
        case .dark: return .dark
        case .light: return .light
        }
    }

    static func fromColorScheme(_ colorScheme: ColorScheme) -> Self {
        switch colorScheme {
        case .light: return .light
        case .dark: return .dark
        @unknown default: return .auto
        }
    }
}
