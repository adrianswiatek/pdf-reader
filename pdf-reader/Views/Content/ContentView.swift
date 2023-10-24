import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(PageListener.self) 
    private var pageListener: PageListener

    @Environment(BookProgressStore.self)
    private var bookProgressStore: BookProgressStore

    @Environment(\.modelContext) 
    private var modelContext: ModelContext

    @State private var isOutlineShown = false
    @State private var isPageNumberAlertShown = false
    @State private var isFilePickerShown = false
    @State private var areControlsShown = false
    @State private var pdfKitView = PdfKitView()

    private var outlineView: OutlineView {
        OutlineView(
            outline: pdfKitView.outline,
            isShown: $isOutlineShown,
            onPageSelected: pdfKitView.goTo
        )
    }

    private var pdfNavigationButtonsView: PdfButtonsView {
        PdfButtonsView(
            pdfKitView: pdfKitView,
            isOutlineShown: $isOutlineShown,
            isPageNumberAlertShown: $isPageNumberAlertShown,
            areButtonsShown: $areControlsShown
        )
    }

    private var closeAndSwitchButtonsView: some View {
        VStack(spacing: 16) {
            PdfButton(imageSystemName: "xmark") {
                withAnimation {
                    pdfKitView.closeDocument()
                    areControlsShown.toggle()
                    pageListener.clearState()
                }
            }

            PdfButton(imageSystemName: "arrow.triangle.2.circlepath") {
                isFilePickerShown.toggle()
                areControlsShown.toggle()
                pageListener.clearState()
            }
        }
    }

    private var statusBarBackground: some View {
        Rectangle()
            .fill(.background.opacity(0.8))
            .frame(height: 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var canShowPdfContent: Bool {
        pdfKitView.isPdfLoaded
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
                    VStack(spacing: 16) {
                        if canShowOutlineButton {
                            PdfButton(imageSystemName: "list.number", isActive: isOutlineShown) {
                                withAnimation {
                                    isOutlineShown.toggle()
                                    areControlsShown.toggle()
                                }
                            }
                        }

                        PdfButton(imageSystemName: "ellipsis.rectangle", isActive: areControlsShown) {
                            withAnimation {
                                areControlsShown.toggle()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)

                    if areControlsShown {
                        PageNumber()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding()

                        closeAndSwitchButtonsView
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .padding()

                        pdfNavigationButtonsView
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    }
                }
            } else {
                ContentUnavailableView {
                    Image(systemName: "book.closed.circle.fill")
                        .font(.system(size: 72))
                        .symbolEffect(.scale)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.orange)
                    Text("No PDF document opened")
                } actions: {
                    Button("Select a document") {
                        isFilePickerShown.toggle()
                    }
                    .font(.title2)
                    .buttonStyle(.borderless)
                    .padding()
                }
                .background(Color(uiColor: .systemBackground).gradient)
            }
        }
        .fileImporter(isPresented: $isFilePickerShown, allowedContentTypes: [.pdf]) { result in
            if case .success(let url) = result {
                pdfKitView.loadDocumentWithUrl(url)
            }
        }
        .alert("Go to page", isPresented: $isPageNumberAlertShown) {
            PageNumberAlertView {
                pdfKitView.goTo($0)
                areControlsShown.toggle()
            }
        }
        .onAppear {
            bookProgressStore.modelContext = modelContext
            pdfKitView.bookProgressStore = bookProgressStore
        }
    }
}
