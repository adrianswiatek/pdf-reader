import SwiftUI

struct OutlineView: View {
    @Binding
    private var isShown: Bool

    @State
    private var selectedNode: Outline.Node?

    @State
    private var searchTerm: String

    private let outline: Outline
    private let onPageSelected: (PdfKitView.Destination) -> Void

    init(
        outline: Outline,
        isShown: Binding<Bool>,
        onPageSelected: @escaping (PdfKitView.Destination) -> Void
    ) {
        self._isShown = isShown
        self.outline = outline
        self.onPageSelected = onPageSelected
        self._searchTerm = State(wrappedValue: "")
    }

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(isOutlineShown: $isShown, searchTerm: $searchTerm)
                .frame(height: 56)

            List {
                RowsView(nodes, selectedNode: $selectedNode)
                    .listRowBackground(Color(uiColor: .systemBackground))
            }
            .listStyle(.automatic)
        }
        .opacity(isShown ? 1 : 0)
        .onChange(of: selectedNode) {
            withAnimation {
                isShown = false
            }

            if let page = $0?.pdfDestination?.page {
                onPageSelected(.page(page))
            }
        }
    }

    private var nodes: [Outline.Node] {
        outline.searched(searchTerm).nodes.map {
            $0.withUnderlinedLabel(searchTerm)
        }
    }
}
