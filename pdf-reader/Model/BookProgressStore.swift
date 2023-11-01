import Combine
import Foundation
import SwiftData

@Observable
final class BookProgressStore {
    var modelContext: ModelContext?

    private var currentBookProgress: BookProgress?

    private let pageListener: PageListener
    private var cancellables: Set<AnyCancellable>

    init(pageListener: PageListener) {
        self.pageListener = pageListener
        self.cancellables = []
        self.bind()
    }

    func addBookProgress(_ bookProgress: BookProgress) {
        modelContext?.insert(bookProgress)
    }

    func fetchBookProgressForUrl(_ url: URL) -> BookProgress? {
        let fetchDescriptor = FetchDescriptor<BookProgress>()
        let booksProgresses = try? modelContext?.fetch(fetchDescriptor)
        return booksProgresses?.first { $0.url == url }
    }

    func setAsCurrentBookProgressWithUrl(_ url: URL) {
        currentBookProgress = fetchBookProgressForUrl(url)
    }

    private func bind() {
        pageListener
            .currentPagePublisher
            .compactMap { $0?.pageIndex }
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.currentBookProgress?.page = $0
                try? self?.modelContext?.save()
            }
            .store(in: &cancellables)
    }
}
