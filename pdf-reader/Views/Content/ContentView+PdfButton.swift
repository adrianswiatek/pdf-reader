import SwiftUI

extension ContentView {
    struct PdfButton: View {
        private let imageSystemName: String
        private let action: () -> Void

        private let font: Font
        private let fontWeight: Font.Weight
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

            self.tintColor = switch (isActive, isDisabled) {
            case (_, true): .gray.opacity(0.5)
            case (true, _): .activeColor
            default: .accentColor
            }
        }

        var body: some View {
            Button(action: action) {
                Image(systemName: imageSystemName)
                    .font(font)
                    .fontWeight(.medium)
                    .tint(tintColor)
                    .frame(width: 40, height: 40)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 60)
                        .fill(.white.opacity(0.66))
                        .shadow(color: .blue.opacity(0.33), radius: 0.5, y: 0.5))
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
