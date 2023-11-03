import Foundation
import SwiftData

@Model
final class BookProgress {
    var page: Int

    let dateOfUpdate: Date
    let pageIndex: Int
    let title: String
    let url: URL

    init(url: URL, page: Int) {
        self.url = url
        self.page = page

        self.title = String(url.lastPathComponent.dropLast(4))
        self.pageIndex = page - 1
        self.dateOfUpdate = Date()
    }

    convenience init(withUrl url: URL) {
        self.init(url: url, page: 0)
    }
}
