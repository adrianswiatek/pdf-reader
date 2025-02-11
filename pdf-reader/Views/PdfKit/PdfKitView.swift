import Combine
import PDFKit
import SwiftUI

struct PdfKitView: UIViewRepresentable {
    var bookProgressStore: BookProgressStore?

    private(set) var isPdfLoaded: Bool = false

    var outline: Outline {
        pdfView.document.flatMap(Outline.makeFromDocument) ?? .empty
    }

    private let pdfView = PDFView()

    func makeUIView(context: Context) -> PDFView {
        pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        // No need to update
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

    mutating func loadDocumentWithSecurityScopedUrl(_ url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            return
        }

        loadDocumentWithUrl(url)
        url.stopAccessingSecurityScopedResource()
    }

    mutating func loadDocumentWithUrl(_ url: URL) {
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true

        setIsPdfLoaded()
        setBookProgressForUrl(url)
    }

    private func setBookProgressForUrl(_ url: URL) {
        if let bookProgress = bookProgressStore?.fetchBookProgressForUrl(url) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                goTo(.index(bookProgress.pageIndex))
            }
        } else {
            bookProgressStore?.addBookProgress(BookProgress(withUrl: url))
        }
        bookProgressStore?.setAsCurrentBookProgressWithUrl(url)
    }

    mutating func closeDocument() {
        pdfView.document = nil
        setIsPdfLoaded()
    }

    private mutating func setIsPdfLoaded() {
        isPdfLoaded = pdfView.document != nil
    }
}
