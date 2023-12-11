import Combine
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme)
    private var colorScheme: ColorScheme

    @Environment(PageListener.self)
    private var pageListener: PageListener

    @Environment(BookProgressStore.self)
    private var bookProgressStore: BookProgressStore

    @Environment(\.modelContext)
    private var modelContext: ModelContext

    @State private var areControlsShown = false
    @State private var areSettingsShown = false
    @State private var canShowPdfContent = false
    @State private var isFilePickerShown = false
    @State private var isHistoryShown = false
    @State private var isOutlineShown = false
    @State private var isPageNumberAlertShown = false
    @State private var shouldShowPageNumber = false
    @State private var pdfKitView = PdfKitView()

    @State private var timer = makeTimerPublisher(withInterval: 0)

    private var outlineView: OutlineView {
        OutlineView(
            outline: pdfKitView.outline.withCurrentPage(pageListener.currentPage),
            isShown: $isOutlineShown,
            onPageSelected: pdfKitView.goTo
        )
    }

    private var statusBarBackground: some View {
        Rectangle()
            .fill(.background.opacity(0.8))
            .frame(height: 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var contentButtonsView: some View {
        ContentButtonsView(
            canShowOutlineButton: canShowOutlineButton,
            areControlsShown: $areControlsShown,
            isFilePickerShown: $isFilePickerShown,
            isOutlineShown: $isOutlineShown,
            isPageNumberAlertShown: $isPageNumberAlertShown,
            shouldShowPageNumber: $shouldShowPageNumber,
            pdfKitView: $pdfKitView
        )
    }

    private var canShowOutline: Bool {
        !pdfKitView.outline.isEmpty
    }

    private var canShowButtons: Bool {
        !isPageNumberAlertShown && !isOutlineShown
    }

    private var canShowOutlineButton: Bool {
        pdfKitView.outline.isEmpty == false && areControlsShown
    }

    var body: some View {
        ZStack {
            if canShowPdfContent {
                pdfKitView
                    .ignoresSafeArea()
                    .opacity(isOutlineShown ? 0 : 1)

                statusBarBackground
                    .ignoresSafeArea()

                if canShowOutline {
                    outlineView
                }

                if canShowButtons {
                    contentButtonsView
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                }
            } else {
                NoContentView($areSettingsShown, $isFilePickerShown, $isHistoryShown)
            }
        }
        .fileImporter(isPresented: $isFilePickerShown, allowedContentTypes: [.pdf]) {
            if case .success(let url) = $0 {
                pdfKitView.loadDocumentWithSecurityScopedUrl(url)
            }
        }
        .alert("Go to page", isPresented: $isPageNumberAlertShown) {
            PageNumberAlertView {
                pdfKitView.goTo($0)
                areControlsShown.toggle()
            }
        }
        .sheet(isPresented: $isHistoryShown) {
            HistoryView()
        }
        .sheet(isPresented: $areSettingsShown) {
            SettingsView()
                .preferredColorScheme(colorScheme)
        }
        .onAppear {
            bookProgressStore.modelContext = modelContext
            pdfKitView.bookProgressStore = bookProgressStore
        }
        .onChange(of: pdfKitView.isPdfLoaded) {
            canShowPdfContent = $1
        }
        .onChange(of: pageListener.currentPage) {
            withAnimation {
                shouldShowPageNumber = true
            }
            timer = ContentView.makeTimerPublisher(withInterval: 2.5)
        }
        .onChange(of: areControlsShown) {
            if !$1 {
                withAnimation {
                    shouldShowPageNumber = false
                }
            }
        }
        .onReceive(timer, perform: { _ in
            withAnimation {
                shouldShowPageNumber = false
            }
        })
        .onOpenURL {
            pdfKitView.loadDocumentWithUrl($0)
        }
    }

    private static func makeTimerPublisher(
        withInterval seconds: Double
    ) -> Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: seconds, on: .main, in: .common).autoconnect()
    }
}
