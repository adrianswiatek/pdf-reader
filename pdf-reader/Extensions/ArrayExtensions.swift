import PDFKit

extension Array {
    var head: Element {
        self[0]
    }

    var tail: [Element] {
        Array(dropFirst())
    }
}

extension Array where Element == Outline.Node {
    static func nodesFromOutline(_ pdfOutline: PDFOutline) -> [Outline.Node] {
        (0 ..< pdfOutline.numberOfChildren)
            .compactMap(pdfOutline.child)
            .map(Outline.Node.fromPdfOutline)
    }
}
