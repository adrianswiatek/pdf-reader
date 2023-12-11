import SwiftUI

extension OutlineView {
    struct RowView: View {
        @Environment(PageListener.self)
        private var pageListener: PageListener

        @Environment(\.colorScheme)
        private var colorScheme: ColorScheme

        @Binding
        private var selectedNode: Outline.Node?

        private let node: Outline.Node
        private let level: CGFloat
        private let isCurrent: Bool

        private var backgroundColorForText: Color {
            isCurrent ? Color(uiColor: .systemPurple).opacity(0.33) : .clear
        }

        private var backgroundColorForFoundText: Color {
            .yellow.opacity(0.5)
        }

        private var canShowPageNumber: Bool {
            node.page?.hasPageNumber == true
        }

        private var canShowPageLabel: Bool {
            node.page?.hasPageLabel == true && node.page?.arePropertiesTheSame == false
        }

        init(
            node: Outline.Node,
            level: Int,
            isCurrent: Bool,
            selectedNode: Binding<Outline.Node?>
        ) {
            self.node = node
            self.level = CGFloat(level)
            self.isCurrent = isCurrent
            self._selectedNode = selectedNode
        }

        var body: some View {
            HStack(spacing: 0) {
                Text(node.label.underlinedText().preunderlined)
                    .font(.system(size: 18 - level * 1.5))
                    .fontWeight(fontWeightForLevel(Int(level)))
                    .background(backgroundColorForText)

                Text(node.label.underlinedText().underlined)
                    .font(.system(size: 18 - level * 1.5))
                    .fontWeight(fontWeightForLevel(Int(level)))
                    .padding(.vertical, 2)
                    .background(backgroundColorForFoundText)

                Text(node.label.underlinedText().postunderlined)
                    .font(.system(size: 18 - level * 1.5))
                    .fontWeight(fontWeightForLevel(Int(level)))
                    .background(backgroundColorForText)

                Spacer()

                if canShowPageNumber {
                    HStack(spacing: 2) {
                        if canShowPageLabel {
                            Text(node.page?.pageNumber ?? "")
                                .fontWeight(.thin)
                            Text(" | ")
                                .fontWeight(.thin)
                            Text(node.page?.pageLabel ?? "")
                                .fontWeight(.medium)
                        } else {
                            Text(node.page?.pageNumber ?? "")
                                .fontWeight(.light)
                        }
                    }
                    .font(.system(size: 14))
                    .background(backgroundColorForText)
                }
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
