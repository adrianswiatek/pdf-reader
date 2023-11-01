func curry<A, B, C>(_ fn: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in
        return { b in
            return fn(a, b)
        }
    }
}

func uncurry<A, B, C>(_ fn: @escaping ((A) -> (B) -> C)) -> (A, B) -> C {
    return { (a, b) in
        return fn(a)(b)
    }
}

func flip<A, B, C>(_ fn: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { b in
        return { a in
            return fn(a)(b)
        }
    }
}

infix operator * : AdditionPrecedence

func * <A, B, C>(_ fn1: @escaping (B) -> C, _ fn2: @escaping (A) -> B) -> (A) -> C {
    return { a in
        fn1(fn2(a))
    }
}
