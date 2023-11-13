import SwiftUI

extension ColorScheme: RawRepresentable {
    public init?(rawValue: String) {
        self = rawValue == "dark" ? .dark : .light
    }

    public var rawValue: String {
        if case .dark = self {
            return "dark"
        }
        return "light"
    }
}
