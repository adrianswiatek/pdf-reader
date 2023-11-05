import SwiftUI

extension ContentView {
    struct PdfButton: View {
        private let imageSystemName: String
        private let action: () -> Void

        private let font: Font
        private let fontWeight: Font.Weight
        private let side: CGFloat
        private let tintColor: Color

        init(
            imageSystemName: String,
            size: Size = .regular,
            isActive: Bool = false,
            isDisabled: Bool = false,
            action: @escaping () -> Void
        ) {
            self.imageSystemName = imageSystemName
            self.action = isDisabled ? { } : action

            self.font = size == .regular ? .title : .title3
            self.fontWeight = isDisabled ? .thin : .medium
            self.side = size == .regular ? 40 : 32

            self.tintColor = switch (isActive, isDisabled) {
            case (_, true): .gray.opacity(0.5)
            case (true, _): .activeColor
            default: .black
            }
        }

        var body: some View {
            Button(action: action) {
                Image(systemName: imageSystemName)
                    .font(font)
                    .fontWeight(.light)
                    .tint(tintColor)
                    .frame(width: side, height: side)
                    .padding(4)
                    .background(DefaultBackgroundView())
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
