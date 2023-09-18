import SwiftUI

extension ContentView {
    struct PageNumberAlertView: View {
        @State
        private var pageNumber: String

        private let onAccept: (PdfKitView.Destination) -> Void

        init(onAccept: @escaping (PdfKitView.Destination) -> Void) {
            self.onAccept = onAccept
            self._pageNumber = State(wrappedValue: "")
        }

        var body: some View {
            TextField("Page number", text: $pageNumber)
                .keyboardType(.numberPad)

            Button("OK") {
                if let pageIndex = Int(pageNumber) {
                    onAccept(.index(pageIndex))
                    pageNumber = ""
                }
            }

            Button("Cancel", role: .cancel) {}
        }
    }
}
