import Foundation
import PDFKit

extension Outline {
    struct Node: Hashable, Identifiable {
        let id: UUID
        let label: Label
        let pageNumber: Int?
        let pdfDestination: PDFDestination?
        let children: [Node]

        var formattedPageNumber: String {
            pageNumber.map(String.init) ?? ""
        }

        init(
            _ id: UUID,
            _ label: Label,
            _ pageNumber: Int?,
            _ pdfDestination: PDFDestination?,
            _ childs: [Node]
        ) {
            self.id = id
            self.label = label
            self.pageNumber = pageNumber
            self.pdfDestination = pdfDestination
            self.children = childs
        }

        static func fromPdfOutline(_ pdfOutline: PDFOutline) -> Node {
            let id = UUID()
            let label = Label.fromString(pdfOutline.label ?? "")
            let pageNumber = pdfOutline.destination?.page?.pageRef?.pageNumber
            let pdfDestination = pdfOutline.destination
            return Node(id, label, pageNumber, pdfDestination, .nodesFromOutline(pdfOutline))
        }

        func withChilds(_ childs: [Node]) -> Node {
            Node(id, label, pageNumber, pdfDestination, childs)
        }

        func withUnderlinedLabel(_ text: String) -> Node {
            Node(id, label.withUnderlined(text), pageNumber, pdfDestination, children.map {
                $0.withUnderlinedLabel(text)
            })
        }
    }
}
