//
//  ArrayMutation.swift
//  DiffOnUniqueSortedArray
//
//  Created by Hoon H. on 2016/11/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

///
/// Describes a mutation on an array.
///
/// - Note:
///     Intentionally passes collection parameters to increase
///     efficiency by batching mutations on dense range.
///
public enum ArrayMutation<T> {
    case insert(CountableRange<Array<T>.Index>, [T])
    case update(CountableRange<Array<T>.Index>, [T])
    case delete(CountableRange<Array<T>.Index>, [T])
}

public extension ArrayMutation {
    public func eonil_map<U>(_ f: (CountableRange<Array<T>.Index>, [T]) -> (CountableRange<Array<T>.Index>, [U])) -> ArrayMutation<U> {
        switch self {
        case .insert(let range, let elements):
            let (range1, elements1) = f(range, elements)
            return .insert(range1, elements1)
        case .update(let range, let elements):
            let (range1, elements1) = f(range, elements)
            return .update(range1, elements1)
        case .delete(let range, let elements):
            let (range1, elements1) = f(range, elements)
            return .delete(range1, elements1)
        }
    }
    public func eonil_map<U>(_ f: (Array<T>.Index, T) -> (U)) -> ArrayMutation<U> {
        switch self {
        case .insert(let range, let elements):
            return .insert(range, Array(zip(range, elements).map(f)))
        case .update(let range, let elements):
            return .update(range, Array(zip(range, elements).map(f)))
        case .delete(let range, let elements):
            return .delete(range, Array(zip(range, elements).map(f)))
        }
    }
}

///
/// - Note:
///     Cannot conform `Equatable` due to lack of conditional protocol conformance...
///
extension ArrayMutation where T: Equatable {
    static func == (_ a: ArrayMutation<T>, _ b: ArrayMutation<T>) -> Bool {
        switch (a, b) {
        case (let .insert(r1, e1), let .insert(r2, e2)):    return r1 == r2 && e1 == e2
        case (let .update(r1, e1), let .update(r2, e2)):    return r1 == r2 && e1 == e2
        case (let .delete(r1, e1), let .delete(r2, e2)):    return r1 == r2 && e1 == e2
        default:                                            return false
        }
    }
}

