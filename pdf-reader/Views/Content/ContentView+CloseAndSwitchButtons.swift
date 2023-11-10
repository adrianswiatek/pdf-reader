import SwiftUI

extension ContentView {
    struct CloseAndSwitchButtonsView: View {
        @Environment(PageListener.self)
        private var pageListener: PageListener

        @Binding 
        private var areControlsShown: Bool

        @Binding 
        private var isFilePickerShown: Bool

        @Binding 
        private var pdfKitView: PdfKitView

        init(
            areControlsShown: Binding<Bool>,
            isFilePickerShown: Binding<Bool>,
            pdfKitView: Binding<PdfKitView>
        ) {
            self._areControlsShown = areControlsShown
            self._isFilePickerShown = isFilePickerShown
            self._pdfKitView = pdfKitView
        }

        var body: some View {
            VStack(spacing: 16) {
                PdfButton(imageSystemName: "xmark") {
                    withAnimation {
                        pdfKitView.closeDocument()
                        areControlsShown.toggle()
                        pageListener.clearState()
                    }
                }

                PdfButton(imageSystemName: "arrow.triangle.2.circlepath", size: .small) {
                    isFilePickerShown.toggle()
                    areControlsShown.toggle()
                    pageListener.clearState()
                }
            }
        }
    }
}
