import SwiftUI

extension OutlineView {
    struct RowsView: View {
        @Binding private var selectedNode: Outline.Node?

        private let nodes: [Outline.Node]
        private let level: Int
        private let currentNode: Outline.Node?

        init(
            nodes: [Outline.Node],
            level: Int = 0,
            currentNode: Outline.Node?,
            selectedNode: Binding<Outline.Node?>
        ) {
            self.nodes = nodes
            self.level = level
            self.currentNode = currentNode
            self._selectedNode = selectedNode
        }

        var body: some View {
            ForEach(nodes, id: \.self) {
                rowViewForNode($0)
                rowsViewForNode($0)
            }
        }

        private func rowViewForNode(_ node: Outline.Node) -> RowView {
            RowView(
                node: node,
                level: level,
                isCurrent: currentNode == node,
                selectedNode: $selectedNode
            )
        }

        private func rowsViewForNode(_ node: Outline.Node) -> RowsView {
            RowsView(
                nodes: node.children,
                level: level + 1,
                currentNode: currentNode,
                selectedNode: $selectedNode
            )
        }
    }
}
