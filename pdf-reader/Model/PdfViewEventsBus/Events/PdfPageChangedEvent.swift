import PDFKit

struct PdfPageChangedEvent {
    let label: String?
    let pageNumber: Int?

    static func fromPdfPage(_ pdfPage: PDFPage) -> PdfPageChangedEvent {
        .init(label: pdfPage.label, pageNumber: pdfPage.pageRef?.pageNumber)
    }
}
