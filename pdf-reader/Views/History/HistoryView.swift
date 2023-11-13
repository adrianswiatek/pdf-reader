import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(BookProgressStore.self)
    private var bookProgressStore: BookProgressStore

    @Environment(\.dismiss)
    private var dismiss: DismissAction

    @AppStorage(StorageKey.sortingOption)
    private var sortingOption: SortingOption = .name

    @Query
    private var unsortedBookProgresses: [BookProgress]

    @State
    private var isClearAllAlertShown: Bool = false

    private var bookProgresses: [BookProgress] {
        unsortedBookProgresses.sorted(by: areInIncreasingOrder)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(bookProgresses, id: \.self) { bookProgress in
                    HStack {
                        Text(bookProgress.title)
                        Spacer()
                        Text(bookProgress.page.description)
                    }
                }
                .onDelete(perform: deleteBookProgress)
                .listRowBackground(Color.clear)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isClearAllAlertShown.toggle()
                    } label: {
                        Image(systemName: "trash")
                        Text("clear all")
                            .fontWeight(.light)
                    }
                    .tint(Color(uiColor: .label).opacity(0.66))
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        sortingOption.toggle()
                    } label: {
                        Image(systemName: "arrow.up.and.down.text.horizontal")
                        HStack(spacing: 2) {
                            Text("sort by:")
                                .fontWeight(.light)

                            Text(sortingOption.rawValue)
                                .fontWeight(.regular)
                        }
                    }
                    .tint(Color(uiColor: .label).opacity(0.66))
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .tint(Color(uiColor: .label).opacity(0.66))
                    }
                }
            }
        }
        .alert("Are you sure?", isPresented: $isClearAllAlertShown, actions: {
            Button(role: .destructive, action: bookProgressStore.deleteAllBookProgresses) {
                Text("Yes")
            }

            Button(role: .cancel, action: doNothing) {
                Text("Cancel")
            }
        }, message: {
            Text("You are about to remove all entries")
        })
        .onChange(of: bookProgresses) { _, bookProgresses in
            bookProgresses.ifEmpty { dismiss() }
        }
    }

    private func deleteBookProgress(_ indexSet: IndexSet) {
        guard let index = indexSet.first else {
            return
        }
        bookProgressStore.deleteBookProgress(bookProgresses[index])
        deleteBookProgress(indexSet.tail)
    }

    private func areInIncreasingOrder(lhs: BookProgress, rhs: BookProgress) -> Bool {
        switch sortingOption {
        case .lastUpdate: 
            lhs.dateOfUpdate > rhs.dateOfUpdate
        case .name:
            lhs.title < rhs.title
        }
    }
}

private extension HistoryView {
    enum SortingOption: String {
        case lastUpdate = "last update"
        case name

        mutating func toggle() {
            switch self {
            case .lastUpdate:
                self = .name
            case .name:
                self = .lastUpdate
            }
        }
    }
}
