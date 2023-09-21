import Combine
import Foundation
import PDFKit

final class PdfViewEventsBus {
    var events: AnyPublisher<PdfViewEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let notificationCenter: NotificationCenter
    private let eventsSubject: PassthroughSubject<PdfViewEvent, Never>
    private var cancellables: Set<AnyCancellable>

    init() {
        self.notificationCenter = .default
        self.eventsSubject = .init()
        self.cancellables = []
        self.bind()
    }

    private func bind() {
        notificationCenter
            .publisher(for: .PDFViewPageChanged)
            .compactMap { ($0.object as? PDFView).flatMap(\.currentPage) }
            .sink { [weak self] in
                self?.eventsSubject.send(.pageChanged(.fromPdfPage($0)))
            }
            .store(in: &cancellables)
    }
}
