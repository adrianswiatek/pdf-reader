import SwiftUI

extension OutlineView {
    struct RowView: View {
        @Environment(\.colorScheme)
        private var colorScheme: ColorScheme

        @Binding
        private var selectedNode: Outline.Node?

        private let node: Outline.Node
        private let level: CGFloat

        init(_ node: Outline.Node, level: Int, selectedNode: Binding<Outline.Node?>) {
            self.node = node
            self.level = CGFloat(level)
            self._selectedNode = selectedNode
        }

        var body: some View {
            HStack(spacing: 0) {
                Text(node.label.underlinedText().preunderlined)
                    .font(.system(size: 18 - level * 1.5))
                    .fontWeight(fontWeightForLevel(Int(level)))

                Text(node.label.underlinedText().underlined)
                    .font(.system(size: 18 - level * 1.5))
                    .fontWeight(fontWeightForLevel(Int(level)))
                    .background(Color(uiColor: .yellow).opacity(0.5))

                Text(node.label.underlinedText().postunderlined)
                    .font(.system(size: 18 - level * 1.5))
                    .fontWeight(fontWeightForLevel(Int(level)))

                Spacer()

                Text(node.pageNumber)
                    .font(.system(size: 14))
                    .fontWeight(.light)
            }
            .foregroundColor(Color(uiColor: colorScheme == .light ? .darkText : .lightText))
            .padding(.leading, level * 20)
            .frame(height: 18)
            .background(Color(uiColor: .systemBackground))
            .onTapGesture { selectedNode = node }
        }

        private func fontWeightForLevel(_ level: Int) -> Font.Weight {
            let fontWeights: [Font.Weight] = [.medium, .regular, .light]
            let index = min(level, fontWeights.count - 1)
            return fontWeights[index]
        }
    }
}
