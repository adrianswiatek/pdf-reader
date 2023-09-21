import SwiftUI

extension ContentView {
    struct PageNumber: View {
        @EnvironmentObject
        private var currentPageListener: CurrentPageListener

        @Binding
        private var mode: Mode

        init(mode: Binding<Mode>) {
            self._mode = mode
        }

        private var canShowButton: Bool {
            let hasBothProperties = 
                currentPageListener.hasPageLabel &&
                currentPageListener.hasPageNumber

            let bothPropertiesAreDifferent =
                currentPageListener.pageLabel !=
                currentPageListener.pageNumber

            return hasBothProperties && bothPropertiesAreDifferent
        }

        private var textToDisplay: String {
            let pageNumber = currentPageListener.pageNumber
            let pageLabel = currentPageListener.pageLabel?.uppercased()

            switch mode {
            case .pageNumber:
                return pageNumber ?? pageLabel ?? ""
            case .pageLabel:
                return pageLabel ?? pageNumber ?? ""
            }
        }

        var body: some View {
            if canShowButton {
                Button(action: toggleMode) {
                    pageNumber
                }
            } else {
                pageNumber
            }
        }

        private var pageNumber: some View {
            Text(textToDisplay)
                .foregroundColor(.accentColor)
                .frame(height: 44)
                .frame(minWidth: 44)
                .padding(.horizontal, 2)
                .background(RoundedRectangle(cornerRadius: 60)
                    .fill(.white.opacity(0.66))
                    .shadow(color: .blue.opacity(0.33), radius: 0.5, y: 0.5))
        }

        private func toggleMode() {
            mode = mode.toggled()
        }
    }
}

extension ContentView.PageNumber {
    enum Mode {
        case pageNumber
        case pageLabel

        func toggled() -> Mode {
            self == .pageNumber ? .pageLabel : .pageNumber
        }
    }
}
