import Foundation
import SwiftData

@Model
final class BookProgress {
    var dateOfUpdate: Date
    var page: Int
    var title: String

    var pageIndex: Int {
        max(0, page - 1)
    }

    init(url: URL, page: Int) {
        self.title = BookProgress.titleFromUrl(url)
        self.page = page
        self.dateOfUpdate = Date()
    }

    convenience init(withUrl url: URL) {
        self.init(url: url, page: 0)
    }

    func updatePage(_ page: Int) {
        self.page = page
        self.dateOfUpdate = Date()
    }
}

extension BookProgress {
    static func hasTheSameTitle(_ url: URL) -> (BookProgress) -> Bool {
        return { bookProgress in
            return bookProgress.title == BookProgress.titleFromUrl(url)
        }
    }

    private static func titleFromUrl(_ url: URL) -> String {
        String(url.lastPathComponent.dropLast(4))
    }
}
