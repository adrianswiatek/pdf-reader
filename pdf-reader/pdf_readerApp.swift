import SwiftUI

@main
struct pdf_readerApp: App {
    private let pageListener: PageListener =
        PageListener(notificationCenter: .default)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(pageListener)
        }
    }
}
