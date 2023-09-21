import PDFKit
import SwiftUI

struct PdfKitView: UIViewRepresentable {
    var isPdfLoaded: Bool {
        pdfView.document != nil
    }

    var outline: Outline {
        pdfView.document.flatMap(Outline.makeFromDocument) ?? .empty
    }

    private let pdfView = PDFView()

    func makeUIView(context: Context) -> PDFView {
        pdfView.delegate = context.coordinator
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        // No need to update
    }

    func makeCoordinator() -> PdfKitViewDelegate {
        PdfKitViewDelegate()
    }

    func goTo(_ destination: Destination) {
        switch destination {
        case .firstPage:
            pdfView.goToFirstPage(nil)
        case .index(let index):
            if let page = pdfView.document?.page(at: index) {
                goTo(.page(page))
            }
        case .lastPage:
            pdfView.goToLastPage(nil)
        case .nextPage:
            pdfView.goToNextPage(nil)
        case .page(let page):
            pdfView.go(to: page)
        case .previousPage:
            pdfView.goToPreviousPage(nil)
        }
    }

    func loadDocumentWithUrl(_ url: URL) {
        if url.startAccessingSecurityScopedResource() {
            pdfView.document = PDFDocument(url: url)
            url.stopAccessingSecurityScopedResource()
        }
    }

    func closeDocument() {
        pdfView.document = nil
    }
}

extension PdfKitView {
    enum Destination {
        case firstPage
        case index(Int)
        case lastPage
        case nextPage
        case page(PDFPage)
        case previousPage
    }
}

final class PdfKitViewDelegate: NSObject, PDFViewDelegate {
    
}
