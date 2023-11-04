import SwiftUI

extension ContentView.NoContentView {
    struct BaseButtonStyle: ButtonStyle {
        private let isEnabled: Bool
        private let withAccent: Bool

        init(isActive: Bool = true) {
            self.isEnabled = isActive
            self.withAccent = false
        }

        private init(isEnabled: Bool, withAccent: Bool) {
            self.isEnabled = isEnabled
            self.withAccent = withAccent
        }

        func accented() -> BaseButtonStyle {
            BaseButtonStyle(isEnabled: isEnabled, withAccent: true)
        }

        func makeBody(configuration: Configuration) -> some View {
            let fontWeight: Font.Weight = withAccent ? .medium : .regular
            let opacity: Double = opacity(isPressed: configuration.isPressed)

            return configuration.label
                .fontWeight(fontWeight)
                .foregroundColor(Color(uiColor: .label).opacity(opacity))
                .frame(maxHeight: .infinity, alignment: .bottom)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }

        func opacity(isPressed: Bool) -> Double {
            if isEnabled {
                return isPressed ? 0.75 / 2 : 0.75
            } else {
                return 0.25
            }
        }
    }
}
