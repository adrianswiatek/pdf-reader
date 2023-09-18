import SwiftUI

extension OutlineView {
    struct HeaderView: View {
        @Environment(\.colorScheme)
        private var colorScheme: ColorScheme

        @Binding
        private var isShown: Bool

        init(_ isShown: Binding<Bool>) {
            self._isShown = isShown
        }

        var body: some View {
            HStack {
                Text("Outline")
                    .textCase(.uppercase)
                    .foregroundStyle(
                        Color(uiColor: colorScheme == .light ? .darkText : .lightText)
                    )
                    .font(.system(size: 32, weight: .bold))
                    .padding(.leading, 24)

                Spacer()

                Button {
                    withAnimation {
                        isShown.toggle()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .tint(.accentColor)
                        .padding()
                }
                .padding(.trailing, 16)
            }
            .padding(.vertical)
            .background(Color(uiColor: .secondarySystemBackground))
        }
    }
}
