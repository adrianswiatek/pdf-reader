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
