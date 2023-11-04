import Foundation

extension IndexSet {
    var tail: IndexSet {
        IndexSet(dropFirst())
    }
}
