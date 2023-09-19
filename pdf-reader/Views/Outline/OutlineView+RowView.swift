import SwiftUI

extension OutlineView {
    struct RowView: View {
        @Environment(\.colorScheme)
        private var colorScheme: ColorScheme

        private let node: Outline.Node
        private let level: CGFloat

        init(_ node: Outline.Node, level: Int) {
            self.node = node
            self.level = CGFloat(level)
        }

        var body: some View {
            HStack(spacing: 0) {
                Text(node.label.underlinedText().preunderlined)
                    .font(.system(size: 18 - level * 1.5))
                    .fontWeight(fontWeightForLevel(Int(level)))

                Text(node.label.underlinedText().underlined)
                    .font(.system(size: 18 - level * 1.5))
                    .fontWeight(fontWeightForLevel(Int(level)))
                    .background(Color.secondary)

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
        }

        private func fontWeightForLevel(_ level: Int) -> Font.Weight {
            let fontWeights: [Font.Weight] = [.medium, .regular, .light]
            let index = min(level, fontWeights.count - 1)
            return fontWeights[index]
        }
    }
}
