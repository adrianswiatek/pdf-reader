extension Collection {
    func ifEmpty(action: () -> Void) {
        if isEmpty {
            action()
        }
    }

    func ifNotEmpty(action: () -> Void) {
        if !isEmpty {
            action()
        }
    }
}
