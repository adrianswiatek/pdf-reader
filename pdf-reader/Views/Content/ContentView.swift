import SwiftUI

struct ContentView: View {
    @State private var isOutlineShown = false
    @State private var isPageNumberAlertShown = false
    @State private var isFilePickerShown = false
    @State private var areControlsShown = false
    @State private var pdfKitView = PdfKitView()

    private var outlineView: OutlineView {
        OutlineView(
            outline: pdfKitView.outline,
            isShown: $isOutlineShown,
            onPageSelected: pdfKitView.goTo
        )
    }

    private var pdfButtonsView: PdfButtonsView {
        PdfButtonsView(
            pdfKitView: pdfKitView,
            isOutlineShown: $isOutlineShown,
            isPageNumberAlertShown: $isPageNumberAlertShown,
            isFilePickerShown: $isFilePickerShown,
            areButtonsShown: $areControlsShown
        )
    }

    private var statusBarBackground: some View {
        Rectangle()
            .fill(.background.opacity(0.8))
            .frame(height: 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var canShowPdfContent: Bool {
        pdfKitView.isPdfLoaded
    }

    private var canShowOutline: Bool {
        !pdfKitView.outline.isEmpty
    }

    private var canShowButtons: Bool {
        !isPageNumberAlertShown && !isOutlineShown
    }

    private var canShowOutlineButton: Bool {
        pdfKitView.outline.isEmpty == false && areControlsShown
    }

    var body: some View {
        ZStack {
            if canShowPdfContent {
                pdfKitView
                    .ignoresSafeArea()
                    .opacity(isOutlineShown ? 0 : 1)

                statusBarBackground
                    .ignoresSafeArea()

                if canShowOutline {
                    outlineView
                }

                if canShowButtons {
                    VStack(spacing: 16) {
                        if canShowOutlineButton {
                            PdfButton(imageSystemName: "list.number", isActive: isOutlineShown) {
                                withAnimation {
                                    isOutlineShown.toggle()
                                    areControlsShown.toggle()
                                }
                            }
                        }

                        PdfButton(imageSystemName: "ellipsis.rectangle", isActive: areControlsShown) {
                            withAnimation {
                                areControlsShown.toggle()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.trailing, 24)
                    .padding(.bottom, 8)

                    pdfButtonsView
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

                    if areControlsShown {
                        PageNumber()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding()
                    }
                }

            } else {
                VStack(spacing: 24) {
                    Text("No PDF document opened")
                        .foregroundColor(.secondary)
                    Button("Select document") {
                        isFilePickerShown.toggle()
                    }
                }
            }
        }
        .fileImporter(isPresented: $isFilePickerShown, allowedContentTypes: [.pdf]) { result in
            if case .success(let url) = result {
                pdfKitView.loadDocumentWithUrl(url)
            }
        }
        .alert("Go to page", isPresented: $isPageNumberAlertShown) {
            PageNumberAlertView {
                pdfKitView.goTo($0)
                areControlsShown.toggle()
            }
        }
    }
}
