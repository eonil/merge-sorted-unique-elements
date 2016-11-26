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
    case insert(range: CountableRange<Array<T>.Index>, elements: [T])
    case update(range: CountableRange<Array<T>.Index>, elements: [T])
    case delete(range: CountableRange<Array<T>.Index>, elements: [T])
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
