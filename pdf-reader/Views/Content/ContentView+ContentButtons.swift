import SwiftUI

extension ContentView {
    struct ContentButtonsView: View {
        @Binding private var areControlsShown: Bool
        @Binding private var isFilePickerShown: Bool
        @Binding private var isOutlineShown: Bool
        @Binding private var isPageNumberAlertShown: Bool
        @Binding private var shouldShowPageNumber: Bool
        @Binding private var pdfKitView: PdfKitView

        private let canShowOutlineButton: Bool

        init(
            canShowOutlineButton: Bool,
            areControlsShown: Binding<Bool>,
            isFilePickerShown: Binding<Bool>,
            isOutlineShown: Binding<Bool>,
            isPageNumberAlertShown: Binding<Bool>,
            shouldShowPageNumber: Binding<Bool>,
            pdfKitView: Binding<PdfKitView>
        ) {
            self.canShowOutlineButton = canShowOutlineButton

            self._areControlsShown = areControlsShown
            self._isFilePickerShown = isFilePickerShown
            self._isOutlineShown = isOutlineShown
            self._isPageNumberAlertShown = isPageNumberAlertShown
            self._shouldShowPageNumber = shouldShowPageNumber
            self._pdfKitView = pdfKitView
        }

        private var closeAndSwitchButtonsView: some View {
            CloseAndSwitchButtonsView(
                areControlsShown: $areControlsShown,
                isFilePickerShown: $isFilePickerShown,
                pdfKitView: $pdfKitView
            )
        }

        private var goToPageButtonView: PdfButton {
            PdfButton(imageSystemName: "number") {
                isPageNumberAlertShown.toggle()
            }
        }

        private var pdfNavigationButtonsView: NavigationButtonsView {
            NavigationButtonsView(
                pdfKitView: pdfKitView,
                isOutlineShown: $isOutlineShown,
                areButtonsShown: $areControlsShown
            )
        }

        private var optionsButtonView: PdfButton {
            PdfButton(imageSystemName: "ellipsis.rectangle", isActive: areControlsShown) {
                withAnimation {
                    areControlsShown.toggle()
                }
            }
        }

        var body: some View {
            VStack {
                HStack {
                    if areControlsShown || shouldShowPageNumber {
                        PageNumberView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }

                    if areControlsShown {
                        closeAndSwitchButtonsView
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    }
                }

                Spacer()

                VStack(spacing: 16) {
                    if canShowOutlineButton {
                        PdfButton(imageSystemName: "list.number", isActive: isOutlineShown) {
                            withAnimation {
                                isOutlineShown.toggle()
                                areControlsShown.toggle()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    HStack(spacing: 16) {
                        if areControlsShown {
                            goToPageButtonView

                            Spacer()

                            pdfNavigationButtonsView
                        }

                        Spacer()

                        optionsButtonView
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}
