import SwiftUI

extension ContentView {
    struct NoContentView: View {
        @Binding
        private var isFilePickerShown: Bool

        init(_ isFilePickerShown: Binding<Bool>) {
            self._isFilePickerShown = isFilePickerShown
        }

        var body: some View {
            ContentUnavailableView {
                Image(systemName: "book.closed.circle.fill")
                    .font(.system(size: 72))
                    .symbolEffect(.scale)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.orange)
                Text("No PDF document opened")
            } actions: {
                Button("Select a document") {
                    isFilePickerShown.toggle()
                }
                .font(.title2)
                .buttonStyle(.borderless)
                .padding()
            }
            .background(Color(uiColor: .systemBackground).gradient)
        }
    }
}
