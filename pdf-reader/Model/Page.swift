import PDFKit

struct Page: Equatable, Hashable {
    private let pdfPage: PDFPage

    init(pdfPage: PDFPage) {
        self.pdfPage = pdfPage
    }

    var pageIndex: Int? {
        pdfPage.pageRef?.pageNumber
    }

    var pageNumber: String? {
        pageIndex.map(String.init)
    }

    var pageLabel: String? {
        pdfPage.label
    }

    var hasPageLabel: Bool {
        pageLabel?.isEmpty == false
    }

    var hasPageNumber: Bool {
        pageNumber?.isEmpty == false
    }

    var arePropertiesTheSame: Bool {
        pageLabel == pageNumber
    }

    var asPdfPage: PDFPage {
        pdfPage
    }
}
