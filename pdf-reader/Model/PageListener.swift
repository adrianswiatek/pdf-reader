import Combine
import PDFKit

@Observable
final class PageListener {
    private (set) var currentPage: Page?

    var hasCurrentPage: Bool {
        currentPage != nil
    }

    var hasPreviousPage: Bool {
        !previousPages.isEmpty
    }

    private var currentDocument: PDFDocument?
    private var previousPages: [Page]
    private var cancellables: Set<AnyCancellable>

    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
        self.previousPages = []
        self.cancellables = []
        self.bind()
    }

    func previousPage() -> Page? {
        previousPages.last
    }

    private func bind() {
        notificationCenter
            .publisher(for: .PDFViewPageChanged)
            .compactMap { ($0.object as? PDFView).flatMap(\.currentPage) }
            .removeDuplicates()
            .sink { [weak self] in self?.onPageUpdated($0) }
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

        currentPage = incomingPage
    }

    private func appendCurrentPageToHistoryIfNeeded(_ incomingPage: Page) {
        if incomingPage != previousPage(), let currentPage {
            previousPages.append(currentPage)
        }
    }

    private func removeLastPageFromHistoryIfNeeded(_ incomingPage: Page) {
        if incomingPage == previousPage() {
            previousPages.removeLast()
        }
    }

    private func isPageFromCurrentDocument(_ page: Page) -> Bool {
        let currentDocumentUrl = currentDocument?.documentURL
        let pageDocumentUrl = page.asPdfPage.document?.documentURL
        return curry(URL.areEqual) <§> currentDocumentUrl <*> pageDocumentUrl == true
    }
}
