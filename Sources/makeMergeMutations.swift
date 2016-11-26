//
//  makeMergeMutations.swift
//  DiffOnUniqueSortedArray
//
//  Created by Hoon H. on 2016/11/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

///
/// Produces `insert/update` mutations to build a sorted merged array.
///
/// - Parameter decideUpdate:
///     Decides whether to update for the element or not.
///     If `source` and `addition` has equal value, you can choose to
///     update the value in `source` or not by returning `true` or `false`.
///
/// - Returns:
///     An array of insert/update mutations.
///     Mutations are sorted in descending order by index to be valid
///     even on imerative execution.
///
func makeMergeMutations<T: Comparable>(source: [T], addition: [T], decideUpdate: (T) -> (Bool) = { _ in true }) -> [ArrayMutation<T>] {
    assertElementUniqueness(source)
    assertElementUniqueness(addition)
    assertSorted(source)
    assertSorted(addition)

    var g1 = source.enumerated().reversed().makeIterator()
    var g2 = addition.enumerated().reversed().makeIterator()
    var ms = [ArrayMutation<T>]()
    var canContinue = true

    /// Insert missing one.
    /// Update existing one if decided.
    func step(decideUpdate: (T) -> Bool) {
        let n1 = g1.eonil_getPreview()
        let n2 = g2.eonil_getPreview()

        if let n1 = n1, let n2 = n2 {
            if n1.element == n2.element {
                // The element is already in `source`.
                // Update if needed.
                if decideUpdate(n1.element) {
                    let i = source.index(source.startIndex, offsetBy: n1.offset)
                    let r = i..<(i + 1)
                    let es = Array(source[r])
                    let m = ArrayMutation.update(range: r, elements: es)
                    ms.append(m)
                }
                g1.eonil_skip()
                g2.eonil_skip()
                return
            }
            else {
                // The element is missing in `source`.
                if n1.element > n2.element {
                    // Bad position. Skip for good position.
                    g1.eonil_skip()
                    return
                }
                if n1.element < n2.element {
                    // Insert.
                    let i = source.index(source.startIndex, offsetBy: n1.offset)
                    let i1 = source.index(after: i)
                    let r = i1..<(i1 + 1)
                    let es = [n2.element]
                    let m = ArrayMutation.insert(range: r, elements: es)
                    ms.append(m)
                    g2.eonil_skip()
                    return
                }
                fatalError("Unreachable code reached.")
            }
        }
        if let _ = n1 {
            // Everything is already in `source`.
            // Nothing to do.
            canContinue = false
            return
        }
        if let n2 = n2 {
            // Consumed all `source`. Which means remaining `addition`s
            // are all smaller than any `source` element.
            // Add all remaingings at once at first.
            let i2 = addition.index(addition.startIndex, offsetBy: n2.offset + 1) /// Element at current offset need to be included.
            let r2 = addition.startIndex..<i2 ///< Take care that the iteration is reversed.
            let es = Array(addition[r2])
            let i1 = source.startIndex
            let r1 = i1..<(source.index(i1, offsetBy: r2.count))
            let m = ArrayMutation.insert(range: r1, elements: es)
            ms.append(m)
            canContinue = false
            return
        }

        // Consumed all elements from both arrays.
        canContinue = false
    }
    while canContinue {
        step(decideUpdate: decideUpdate)
    }

    assertSorted(ms.reversed().map({ $0.getStartIndex() }))
    assertSorted(ms.reversed().map({ $0.getEndIndex() }))
    return ms
}

private extension ArrayMutation {
    func getStartIndex() -> Int {
        switch self {
        case .insert(let range, _): return range.startIndex
        case .update(let range, _): return range.startIndex
        case .delete(let range, _): return range.startIndex
        }
    }
    func getEndIndex() -> Int {
        switch self {
        case .insert(let range, _): return range.endIndex
        case .update(let range, _): return range.endIndex
        case .delete(let range, _): return range.endIndex
        }
    }
}














