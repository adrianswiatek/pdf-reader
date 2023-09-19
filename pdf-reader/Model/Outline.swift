import PDFKit

struct Outline {
    let nodes: [Node]

    private init(_ nodes: [Node]) {
        self.nodes = nodes
    }

    var isEmpty: Bool {
        nodes.isEmpty
    }

    static var empty: Outline {
        Outline([])
    }

    static func makeFromDocument(_ pdfDocument: PDFDocument) -> Outline? {
        pdfDocument.outlineRoot.map([Outline.Node].nodesFromOutline).map(Outline.init)
    }

    func searched(_ searchTerm: String) -> Outline {
        let isIncluded: (Node) -> Bool = { $0.label.contains(searchTerm) }
        return searchTerm.isEmpty ? self : .init(searched(nodes, isIncluded))
    }

    private func searched(_ nodes: [Node], _ isIncluded: (Node) -> Bool) -> [Node] {
        guard !nodes.isEmpty else { return [] }

        let includedChilds = searched(nodes.header.childs, isIncluded)
        let hasIncludedChilds = includedChilds.isEmpty == false

        return isIncluded(nodes.header) || hasIncludedChilds
            ? [nodes.header.withChilds(includedChilds)] + searched(nodes.tail, isIncluded)
            : searched(nodes.tail, isIncluded)
    }
}
