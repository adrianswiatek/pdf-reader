import SwiftData
import SwiftUI

@main
struct pdf_readerApp: App {
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
        }
        .modelContainer(for: [BookProgress.self])
    }
}
