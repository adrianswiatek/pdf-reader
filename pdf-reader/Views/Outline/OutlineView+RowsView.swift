import SwiftUI

extension OutlineView {
    struct RowsView: View {
        @Binding
        private var selectedNode: Outline.Node?

        private let nodes: [Outline.Node]
        private let level: Int

        init(_ nodes: [Outline.Node], level: Int = 0, selectedNode: Binding<Outline.Node?>) {
            self.nodes = nodes
            self.level = level
            self._selectedNode = selectedNode
        }

        var body: some View {
            ForEach(nodes, id: \.self) {
                RowView($0, level: level, selectedNode: $selectedNode)
                RowsView($0.childs, level: level + 1, selectedNode: $selectedNode)
            }
        }
    }
}
