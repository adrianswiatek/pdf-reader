import SwiftUI

extension PdfKitView {
    @Observable
    final class ViewModel {
        var isPdfLoaded: Bool

        private let bookProgressStore: BookProgressStore

        init(_ bookProgressStore: BookProgressStore) {
            self.bookProgressStore = bookProgressStore
            self.isPdfLoaded = false
        }

        func setBookProgressForUrl(_ url: URL, ifExists: @escaping (Int) -> Void) {
            if let bookProgress = bookProgressStore.fetchBookProgressForUrl(url) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                    ifExists(bookProgress.pageIndex)
                }
            } else {
                bookProgressStore.addBookProgress(BookProgress(withUrl: url))
            }
            bookProgressStore.setAsCurrentBookProgressWithUrl(url)
        }
    }
}
