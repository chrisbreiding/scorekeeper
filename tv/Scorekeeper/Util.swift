func partial<A, T>(fn: (A) -> T, with: A) -> () -> T {
    return { fn(with) }
}

func partial<A, B, T>(fn: (A, B) -> T, with: A) -> (B) -> T {
    return { fn(with, $0) }
}

func partial<A, B, T>(fn: (A, B) -> T, with: A, and: B) -> () -> T {
    return { fn(with, and) }
}

func partial<A, B, C, T>(fn: (A, B, C) -> T, with: A, and: B) -> (C) -> T {
    return { fn(with, and, $0) }
}
