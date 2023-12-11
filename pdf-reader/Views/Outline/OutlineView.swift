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

            if !nodes.isEmpty {
                ScrollViewReader { proxy in
                    List {
                        rowsView
                            .listRowBackground(Color(uiColor: .systemBackground))
                    }
                    .listStyle(.automatic)
                    .onAppear {
                        if let node = outline.currentNode {
                            proxy.scrollTo(node, anchor: .center)
                        }
                    }
                }
            } else {
                ContentUnavailableView.search
                    .background(Color(uiColor: .systemGroupedBackground))
            }
        }
        .opacity(isShown ? 1 : 0)
        .onChange(of: selectedNode) { _, node in
            withAnimation {
                isShown = false
            }

            if let page = node?.pdfDestination?.page {
                onPageSelected(.page(page))
            }
        }
    }

    private var nodes: [Outline.Node] {
        outline.searched(searchTerm).nodes.map {
            $0.withUnderlinedLabel(searchTerm)
        }
    }

    private var rowsView: RowsView {
        RowsView(
            nodes: nodes,
            currentNode: outline.currentNode,
            selectedNode: $selectedNode
        )
    }
}
