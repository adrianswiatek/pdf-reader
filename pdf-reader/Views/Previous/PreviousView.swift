import SwiftUI

struct PreviousView: View {
    @Environment(BookProgressStore.self)
    private var bookProgressStore: BookProgressStore

    @State
    private var bookProgresses: [BookProgress] = []

    var body: some View {
        List {
            ForEach(bookProgresses) { bookProgress in
                HStack {
                    Text(bookProgress.url.relativeString)
                    Spacer()
                    Text(bookProgress.page.description)
                }
            }
            .onDelete(perform: deleteBookProgress)
        }
        .onAppear(perform: updateBookProgresses)
    }

    private func updateBookProgresses() {
        bookProgresses = bookProgressStore.fetchAll().sorted {
            $0.url.relativePath < $1.url.relativePath
        }
    }

    private func deleteBookProgress(_ indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        bookProgressStore.deleteBookProgress(bookProgresses[index])
        updateBookProgresses()
    }
}
