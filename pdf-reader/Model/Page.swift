import PDFKit

struct Page: Equatable {
    private let pdfPage: PDFPage

    init(pdfPage: PDFPage) {
        self.pdfPage = pdfPage
    }

    var pageLabel: String? {
        pdfPage.label
    }

    var pageNumber: Int? {
        pdfPage.pageRef?.pageNumber
    }

    var formattedPageNumber: String? {
        pageNumber.map(String.init)
    }

    var hasPageLabel: Bool {
        pageLabel?.isEmpty == false
    }

    var hasPageNumber: Bool {
        formattedPageNumber?.isEmpty == false
    }

    var arePropertiesTheSame: Bool {
        pageLabel == formattedPageNumber
    }

    var asPdfPage: PDFPage {
        pdfPage
    }
}
