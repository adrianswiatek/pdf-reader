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
                    .fontWeight(.medium)
                    .tint(isActive ? .activeColor : .accentColor)
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
