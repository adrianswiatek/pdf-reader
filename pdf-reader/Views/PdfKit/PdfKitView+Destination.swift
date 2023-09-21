import PDFKit

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
