import SwiftUI

extension OutlineView {
    struct RowsView: View {
        private let nodes: [Outline.Node]
        private let level: Int

        init(_ nodes: [Outline.Node], level: Int = 0) {
            self.nodes = nodes
            self.level = level
        }

        var body: some View {
            ForEach(nodes, id: \.self) {
                RowView($0, level: level)
                RowsView($0.childs, level: level + 1)
            }
        }
    }
}
