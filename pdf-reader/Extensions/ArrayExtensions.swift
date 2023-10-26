import PDFKit

extension Array where Element: Equatable  {
    var head: Element {
        self[0]
    }

    var tail: [Element] {
        last != nil && last != first ? Array(self[1...]) : []
    }
}

extension Array where Element == Outline.Node {
    static func nodesFromOutline(_ pdfOutline: PDFOutline) -> [Outline.Node] {
        (0 ..< pdfOutline.numberOfChildren)
            .compactMap(pdfOutline.child)
            .map(Outline.Node.fromPdfOutline)
    }
}
