import SwiftUI

extension ContentView {
    struct PdfButtonsView: View {
        @Environment(PageListener.self) private var pageListener: PageListener

        @Binding private var isPageNumberAlertShown: Bool
        @Binding private var isOutlineShown: Bool
        @Binding private var areButtonsShown: Bool

        private let pdfKitView: PdfKitView

        init(
            pdfKitView: PdfKitView,
            isOutlineShown: Binding<Bool>,
            isPageNumberAlertShown: Binding<Bool>,
            areButtonsShown: Binding<Bool>
        ) {
            self.pdfKitView = pdfKitView
            self._isOutlineShown = isOutlineShown
            self._isPageNumberAlertShown = isPageNumberAlertShown
            self._areButtonsShown = areButtonsShown
        }

        var body: some View {
            Grid(alignment: .leading, horizontalSpacing: 24) {
                GridRow {
                    if areButtonsShown {
                        PdfButton(imageSystemName: "arrow.uturn.backward", isDisabled: !pageListener.hasPreviousPage) {
                            if let previousPage = pageListener.previousPage() {
                                pdfKitView.goTo(.page(previousPage.asPdfPage))
                            }
                        }

                        PdfButton(imageSystemName: "arrow.left.to.line", size: .small) {
                            pdfKitView.goTo(.firstPage)
                        }

                        PdfButton(imageSystemName: "arrow.left") {
                            pdfKitView.goTo(.previousPage)
                        }

                        PdfButton(imageSystemName: "arrow.right") {
                            pdfKitView.goTo(.nextPage)
                        }

                        PdfButton(imageSystemName: "arrow.right.to.line", size: .small) {
                            pdfKitView.goTo(.lastPage)
                        }

                        PdfButton(imageSystemName: "number") {
                            isPageNumberAlertShown.toggle()
                        }
                    }
                }
            }
            .padding(8)
        }
    }
}
