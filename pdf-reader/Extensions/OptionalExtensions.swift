extension Optional {
    static func just(_ wrapped: Wrapped) -> Wrapped? {
        Optional(wrapped)
    }

    func apply<T>(_ transform: ((Wrapped) -> T)?) -> T? {
        transform.flatMap { map($0) }
    }
}

infix operator <§>: AdditionPrecedence
infix operator <*>: AdditionPrecedence
infix operator >>=: AdditionPrecedence

func <§> <A, B>(_ transform: (A) -> B, _ value: A?) -> B? {
    value.map(transform)
}

func <*> <A, B>(_ transform: ((A) -> B)?, _ value: A?) -> B? {
    value.apply(transform)
}

func >>= <A, B>(_ value: A?, _ transform: (A) -> B?) -> B? {
    value.flatMap(transform)
}
