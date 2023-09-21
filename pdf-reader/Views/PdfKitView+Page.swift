import PDFKit

extension PdfKitView {
    struct Page {
        let label: String
        let number: String

        private init(label: String, index: String) {
            self.label = label
            self.number = index
        }

        static var empty: Page {
            .init(label: "", index: "")
        }

        static func fromPdfPage(_ pdfPage: PDFPage) -> Page {
            Page(
                label: pdfPage.label ?? "",
                index: pdfPage.pageRef.map(\.pageNumber).map(String.init) ?? ""
            )
        }
    }
}
