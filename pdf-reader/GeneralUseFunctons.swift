func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in
        return { b in
            return function(a, b)
        }
    }
}

func uncurry<A, B, C>(_ function: @escaping ((A) -> (B) -> C)) -> (A, B) -> C {
    return { (a, b) in
        return function(a)(b)
    }
}

infix operator * : AdditionPrecedence

func * <A, B, C>(_ fn1: @escaping (B) -> C, _ fn2: @escaping (A) -> B) -> (A) -> C {
    return { a in
        fn1(fn2(a))
    }
}
