import SwiftUI

extension ContentView {
    struct PdfButton: View {
        private let imageSystemName: String
        private let font: Font
        private let isActive: Bool
        private let action: () -> Void

        init(
            imageSystemName: String,
            size: Size = .regular,
            isActive: Bool = false,
            action: @escaping () -> Void
        ) {
            self.imageSystemName = imageSystemName
            self.font = size == .regular ? .title : .title3
            self.isActive = isActive
            self.action = action
        }

        var body: some View {
            Button(action: action) {
                Image(systemName: imageSystemName)
                    .font(font)
                    .tint(isActive ? Color(uiColor: .secondarySystemFill) : .accentColor)
                    .frame(width: 44, height: 44)
            }
        }
    }
}

extension ContentView.PdfButton {
    enum Size {
        case regular
        case small
    }
}
