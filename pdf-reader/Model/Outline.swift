import PDFKit

struct Outline {
    let nodes: [Node]
    let currentNode: Node?

    private init(_ nodes: [Node]) {
        self.nodes = nodes
        self.currentNode = nil
    }

    private init(_ nodes: [Node], _ currentNode: Node?) {
        self.nodes = nodes
        self.currentNode = currentNode
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
        return searchTerm.isEmpty ? self : Outline(searched(nodes, isIncluded))
    }

    private func searched(_ nodes: [Node], _ isIncluded: (Node) -> Bool) -> [Node] {
        guard !nodes.isEmpty else { return [] }

        let includedChildren = searched(nodes.head.children, isIncluded)
        let hasIncludedChildren = includedChildren.isEmpty == false

        return isIncluded(nodes.head) || hasIncludedChildren
            ? [nodes.head.withChilds(includedChildren)] + searched(nodes.tail, isIncluded)
            : searched(nodes.tail, isIncluded)
    }

    func withCurrentPage(_ page: Page?) -> Outline {
        guard let pageIndex = page?.pageIndex else {
            return self
        }

        let isIncluded: (Node) -> Bool = {
            $0.page?.pageIndex.map { $0 <= pageIndex } ?? false
        }

        return Outline(nodes, withClosestToCurrent(nodes, isIncluded))
    }

    private func withClosestToCurrent(_ nodes: [Node], _ isIncluded: (Node) -> Bool) -> Node? {
        if nodes.isEmpty {
            return nil
        }

        let includedChild = withClosestToCurrent(nodes.head.children, isIncluded)
        let includedTail = withClosestToCurrent(nodes.tail, isIncluded)

        let includedNodes: [Node?] = isIncluded(nodes.head)
            ? [nodes.head, includedChild, includedTail]
            : [includedChild, includedTail]

        return includedNodes.compactMap { $0 }.last
    }
}
