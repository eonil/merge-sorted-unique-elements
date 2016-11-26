//
//  Array+ArrayMutation.swift
//  EonilMergeSortedUniqueElements
//
//  Created by Hoon H. on 2016/11/26.
//
//

public extension Array {
    public mutating func eonil_apply(_ mutation: ArrayMutation<Element>) {
        switch mutation {
        case .insert(let range, let elements):
            assert(range.count == elements.count)
            insert(contentsOf: elements, at: range.startIndex)
        case .update(let range, let elements):
            replaceSubrange(range, with: elements)
        case .delete(let range, let elements):
            assert(range.count == elements.count)
            removeSubrange(range)
        }
    }
    public mutating func eonil_apply<S>(_ mutations: S) where S: Sequence, S.Iterator.Element == ArrayMutation<Element> {
        for m in mutations {
            eonil_apply(m)
        }
    }
    public func eonil_applied<S>(_ mutations: S) -> [Element] where S: Sequence, S.Iterator.Element == ArrayMutation<Element> {
        var copy = self
        copy.eonil_apply(mutations)
        return copy
    }
}
