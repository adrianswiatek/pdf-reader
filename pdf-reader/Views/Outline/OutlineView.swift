import SwiftUI

struct OutlineView: View {
    @Binding
    private var isShown: Bool

    @State
    private var selectedNode: Outline.Node?

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
    }

    var body: some View {
        VStack(spacing: 0) {
            HeaderView($isShown)
                .frame(height: 56)

            List(selection: $selectedNode) {
                RowsView(outline.nodes)
                    .listRowBackground(Color(uiColor: .systemBackground))
            }
            .listStyle(.automatic)
        }
        .opacity(isShown ? 1 : 0)
        .onChange(of: selectedNode) { _ in
            withAnimation {
                isShown = false
            }

            if let page = selectedNode?.pdfDestination?.page {
                onPageSelected(.page(page))
            }
        }
    }
}
