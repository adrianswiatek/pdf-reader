import Foundation
import PDFKit

extension Outline {
    struct Node: Hashable, Identifiable {
        let id: UUID
        let label: String
        let pageNumber: String
        let pdfDestination: PDFDestination?
        let childs: [Node]
    }
}

extension Outline.Node {
    static func nodeFromOutline(_ pdfOutline: PDFOutline) -> Outline.Node {
        Outline.Node(
            id: UUID(),
            label: pdfOutline.label ?? "",
            pageNumber: pdfOutline.destination?.page?.label ?? "",
            pdfDestination: pdfOutline.destination,
            childs: .nodesFromOutline(pdfOutline)
        )
    }
}

extension Array where Element == Outline.Node {
    static func nodesFromOutline(_ pdfOutline: PDFOutline) -> [Outline.Node] {
        (0 ..< pdfOutline.numberOfChildren)
            .compactMap(pdfOutline.child)
            .map(Outline.Node.nodeFromOutline)
    }
}
