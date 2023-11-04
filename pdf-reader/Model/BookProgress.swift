import Foundation
import SwiftData

@Model
final class BookProgress {
    var page: Int
    var dateOfUpdate: Date

    let url: URL

    var pageIndex: Int {
        max(0, page - 1)
    }

    var title: String {
        String(url.lastPathComponent.dropLast(4))
    }

    init(url: URL, page: Int) {
        self.url = url
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
