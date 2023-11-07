import SwiftUI

extension ContentView {
    struct NavigationButtonsView: View {
        @Environment(PageListener.self) private var pageListener: PageListener

        @Binding private var isOutlineShown: Bool
        @Binding private var areButtonsShown: Bool

        private let pdfKitView: PdfKitView

        init(
            pdfKitView: PdfKitView,
            isOutlineShown: Binding<Bool>,
            areButtonsShown: Binding<Bool>
        ) {
            self.pdfKitView = pdfKitView
            self._isOutlineShown = isOutlineShown
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

                        PdfButton(imageSystemName: "arrow.uturn.forward", isDisabled: !pageListener.hasAnotherPage) {
                            if let anotherPage = pageListener.anotherPage() {
                                pdfKitView.goTo(.page(anotherPage.asPdfPage))
                            }
                        }
                    }
                }
            }
        }
    }
}
