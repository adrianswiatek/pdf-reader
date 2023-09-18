import PDFKit

struct Outline {
    let nodes: [Node]

    var isEmpty: Bool {
        nodes.isEmpty
    }

    static var empty: Outline {
        Outline(nodes: [])
    }

    static func makeFromDocument(_ pdfDocument: PDFDocument) -> Outline? {
        pdfDocument.outlineRoot.map([Outline.Node].nodesFromOutline).map(Outline.init)
    }
}
