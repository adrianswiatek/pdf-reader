import Combine
import PDFKit

final class CurrentPageListener: ObservableObject {
    @Published private (set) var pageLabel: String?
    @Published private (set) var pageNumber: String?

    var hasPageLabel: Bool {
        pageLabel?.isEmpty == false
    }

    var hasPageNumber: Bool {
        pageNumber?.isEmpty == false
    }

    private let notificationCenter: NotificationCenter
    private var cancellables: Set<AnyCancellable>

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
        self.cancellables = []
        self.bind()
    }

    private func bind() {
        notificationCenter
            .publisher(for: .PDFViewPageChanged)
            .compactMap { ($0.object as? PDFView).flatMap(\.currentPage) }
            .sink { [weak self] in
                self?.pageLabel = $0.label
                self?.pageNumber = $0.pageRef.map(\.pageNumber).map(String.init)
            }
            .store(in: &cancellables)
    }
}

