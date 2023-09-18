import SwiftUI

extension ContentView {
    struct PdfButtonsView: View {
        @Binding private var isPageNumberAlertShown: Bool
        @Binding private var isOutlineShown: Bool
        @Binding private var isFilePickerShown: Bool
        @Binding private var areButtonsShown: Bool

        private let pdfKitView: PdfKitView

        init(
            pdfKitView: PdfKitView,
            isOutlineShown: Binding<Bool>,
            isPageNumberAlertShown: Binding<Bool>,
            isFilePickerShown: Binding<Bool>,
            areButtonsShown: Binding<Bool>
        ) {
            self.pdfKitView = pdfKitView
            self._isOutlineShown = isOutlineShown
            self._isPageNumberAlertShown = isPageNumberAlertShown
            self._isFilePickerShown = isFilePickerShown
            self._areButtonsShown = areButtonsShown
        }

        private var canShowOutlineButton: Bool {
            pdfKitView.outline.isEmpty == false
        }

        var body: some View {
            Grid(horizontalSpacing: 24) {
                GridRow {
                    if areButtonsShown {
                        PdfButton(imageSystemName: "doc") {
                            isFilePickerShown.toggle()
                            areButtonsShown.toggle()
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

                        if canShowOutlineButton {
                            PdfButton(imageSystemName: "list.number", isActive: isOutlineShown) {
                                withAnimation {
                                    isOutlineShown.toggle()
                                    areButtonsShown.toggle()
                                }
                            }
                        }
                    }

                    PdfButton(imageSystemName: "gear", isActive: areButtonsShown) {
                        withAnimation {
                            areButtonsShown.toggle()
                        }
                    }
                }
            }
            .padding(4)
            .background(RoundedRectangle(cornerRadius: 60)
                .fill(.white.opacity(0.75 ))
                .shadow(color: Color(uiColor: .lightGray).opacity(0.75), radius: 0.5, y: 0.5))
        }
    }
}
