import SwiftData
import SwiftUI

@main
struct pdf_readerApp: App {
    @AppStorage(StorageKey.theme)
    private var colorTheme: Settings.Theme = .auto

    private let pageListener: PageListener
    private let bookProgressStore: BookProgressStore

    init() {
        pageListener = PageListener(notificationCenter: .default)
        bookProgressStore = BookProgressStore(pageListener: pageListener)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(pageListener)
                .environment(bookProgressStore)
                .preferredColorScheme(colorTheme.toColorScheme())
        }
        .modelContainer(for: [BookProgress.self])
    }
}
