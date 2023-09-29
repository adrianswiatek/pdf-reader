import PDFKit

struct Page: Equatable {
    private let pdfPage: PDFPage

    init(pdfPage: PDFPage) {
        self.pdfPage = pdfPage
    }

    var pageLabel: String? {
        pdfPage.label
    }

    var pageNumber: String? {
        pdfPage.pageRef.map(\.pageNumber).map(String.init)
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
