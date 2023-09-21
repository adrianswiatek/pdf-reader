import SwiftUI

@main
struct pdf_readerApp: App {
    private let currentPageListener: CurrentPageListener =
        CurrentPageListener(notificationCenter: .default)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(currentPageListener)
        }
    }
}
