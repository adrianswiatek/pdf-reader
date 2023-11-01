import Foundation
import PDFKit

extension Outline {
    struct Node: Hashable, Identifiable {
        let id: UUID
        let label: Label
        let page: Page?
        let pdfDestination: PDFDestination?
        let children: [Node]

        var pageNumber: String {
            page?.pageNumber ?? ""
        }

        init(
            _ id: UUID,
            _ label: Label,
            _ page: Page?,
            _ pdfDestination: PDFDestination?,
            _ childs: [Node]
        ) {
            self.id = id
            self.label = label
            self.page = page
            self.pdfDestination = pdfDestination
            self.children = childs
        }

        static func fromPdfOutline(_ pdfOutline: PDFOutline) -> Node {
            let id = UUID()
            let label = Label.fromString(pdfOutline.label ?? "")
            let page = pdfOutline.destination?.page.map(Page.init)
            let pdfDestination = pdfOutline.destination
            return Node(id, label, page, pdfDestination, .nodesFromOutline(pdfOutline))
        }

        func withChilds(_ childs: [Node]) -> Node {
            Node(id, label, page, pdfDestination, childs)
        }

        func withUnderlinedLabel(_ text: String) -> Node {
            Node(id, label.withUnderlined(text), page, pdfDestination, children.map {
                $0.withUnderlinedLabel(text)
            })
        }
    }
}
