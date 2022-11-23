//
//  Either.swift
//  Cryptify
//
//  Created by Jan Babák on 22.11.2022.
//

import Foundation

//used for decoding array of mixed types (array containing numbers and strings)
//source: https://stackoverflow.com/questions/71526802/swift-decoding-an-array-of-mixed-values
enum Either<A: Decodable, B: Decodable> {
    case left(A)
    case right(B)
    
    func get() -> (A?, B?) {
        switch self {
        case .left(let num): return (num, nil)
        case .right(let num): return (nil, num)
        }
    }
}

extension Either: Decodable {
    struct NeitherError: Error {}
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let a = try? container.decode(A.self) {
            self = .left(a)
        } else if let b = try? container.decode(B.self) {
            self = .right(b)
        } else {
            throw NeitherError()
        }
    }
}
