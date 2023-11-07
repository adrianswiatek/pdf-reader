import Combine
import PDFKit

@Observable
final class PageListener {
    var currentPagePublisher: AnyPublisher<Page?, Never> {
        currentPageSubject.eraseToAnyPublisher()
    }

    private let currentPageSubject: CurrentValueSubject<Page?, Never>

    var currentPage: Page?

    var hasCurrentPage: Bool {
        currentPageSubject.value != nil
    }

    var hasPreviousPage: Bool {
        !previousPages.isEmpty
    }

    var hasAnotherPage: Bool {
        !anotherPages.isEmpty
    }

    private var currentDocument: PDFDocument?
    private var previousPages: [Page]
    private var anotherPages: [Page]
    private var cancellables: Set<AnyCancellable>

    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
        self.currentPageSubject = .init(nil)
        self.previousPages = []
        self.anotherPages = []
        self.cancellables = []
        self.bind()
    }

    func previousPage() -> Page? {
        guard let previousPage = previousPages.last else {
            return nil
        }

        if let currentPage {
            anotherPages.append(currentPage)
        }

        return previousPage
    }

    func anotherPage() -> Page? {
        anotherPages.popLast()
    }

    func clearState() {
        currentDocument = nil
        currentPageSubject.send(nil)
        previousPages.removeAll()
        anotherPages.removeAll()
    }

    private func bind() {
        notificationCenter
            .publisher(for: .PDFViewPageChanged)
            .compactMap { ($0.object as? PDFView).flatMap(\.currentPage) }
            .removeDuplicates()
            .sink { [weak self] in self?.onPageUpdated($0) }
            .store(in: &cancellables)

        currentPagePublisher
            .sink { [weak self] in self?.currentPage = $0 }
            .store(in: &cancellables)
    }

    private func onPageUpdated(_ pdfPage: PDFPage) {
        let incomingPage = Page(pdfPage: pdfPage)

        if isPageFromCurrentDocument(incomingPage) {
            appendCurrentPageToHistoryIfNeeded(incomingPage)
            removeLastPageFromHistoryIfNeeded(incomingPage)
        } else {
            currentDocument = incomingPage.asPdfPage.document
            previousPages.removeAll(keepingCapacity: true)
        }

        currentPageSubject.send(incomingPage)
    }

    private func appendCurrentPageToHistoryIfNeeded(_ incomingPage: Page) {
        if incomingPage != previousPages.last, let currentPage = currentPageSubject.value {
            previousPages.append(currentPage)
        }
    }

    private func removeLastPageFromHistoryIfNeeded(_ incomingPage: Page) {
        if incomingPage == previousPages.last {
            previousPages.removeLast()
        }
    }

    private func isPageFromCurrentDocument(_ page: Page) -> Bool {
        let currentDocumentUrl = currentDocument?.documentURL
        let pageDocumentUrl = page.asPdfPage.document?.documentURL
        return curry(URL.areEqual) <§> currentDocumentUrl <*> pageDocumentUrl == true
    }
}
