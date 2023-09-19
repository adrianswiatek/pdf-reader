import SwiftUI

struct ContentView: View {
    @State private var isOutlineShown = false
    @State private var isPageNumberAlertShown = false
    @State private var isFilePickerShown = false
    @State private var arePdfButtonsShown = false

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
            areButtonsShown: $arePdfButtonsShown
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
                    pdfButtonsView
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
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
                arePdfButtonsShown.toggle()
            }
        }
    }
}
