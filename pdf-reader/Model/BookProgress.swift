import Foundation
import SwiftData

@Model
final class BookProgress {
    var url: URL
    var page: Int

    var pageIndex: Int {
        page - 1
    }

    init(url: URL, page: Int) {
        self.url = url
        self.page = page
    }

    convenience init(withUrl url: URL) {
        self.init(url: url, page: 0)
    }
}
