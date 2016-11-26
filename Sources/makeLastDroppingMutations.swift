//
//  makeTruncateLastMutations.swift
//  DiffOnUniqueSortedArray
//
//  Created by Hoon H. on 2016/11/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

///
/// Produces `delete` mutations to truncate overflown elements in arrays to be merged.
/// This always truncate last items. You can adjust clipping range by setting
/// `maxCount`.
///
/// O(n + m). (excluding misc. like array alloc/dealloc)
///
public func makeTruncateLastMutations<C: RandomAccessCollection>(
    source: C,
    addition: C,
    maxCount: Int)
    -> (source: [ArrayMutation<C.Iterator.Element>], addition: [ArrayMutation<C.Iterator.Element>])
    where
    C.Iterator.Element: Comparable,
    C.Index == Array<C.Iterator.Element>.Index,
    C.IndexDistance == Array<C.Iterator.Element>.Index,
    C.SubSequence.Iterator.Element == C.Iterator.Element
{
    assertElementUniqueness(source)
    assertElementUniqueness(addition)
    assertSorted(source)
    assertSorted(addition)

    typealias I = C.Index
    typealias T = C.Iterator.Element
    typealias EI = EnumeratedIterator<IndexingIterator<Array<C.Iterator.Element>>>

    ///
    /// In given `n == source.count`, and `m == addition.count`;
    ///
    /// - Best: O(m)
    /// - Worst: O(n + m)
    ///
    /// Potentially can be optimized further but it will make things too complex,
    /// and I don't want it.
    ///
    func countUpdateMutations() -> Int {
        var g1 = source.lazy.makeIterator() // Keep source index offset.
        var g2 = addition.lazy.makeIterator() // Keep source index offset.
        var dupc = 0
        var canContinue = true
        func step() {
            let n1 = g1.eonil_getPreview()
            let n2 = g2.eonil_getPreview()
            if let n1 = n1, let n2 = n2 {
                if n1 == n2 {
                    dupc += 1
                    g1.eonil_skip()
                    g2.eonil_skip()
                    return
                }
                // Skip smaller one.
                if n1 < n2 {
                    g1.eonil_skip()
                    return
                }
                if n2 < n1 {
                    g2.eonil_skip()
                    return
                }
                fatalError("Unreachable code reached...")
            }
            canContinue = false
            return
        }
        while canContinue {
            step()
        }
        return dupc
    }

    let updateCount = countUpdateMutations()
    let finalCount = max(0, (source.count + addition.count) - updateCount)
    let maxDeleteMutationCount = max(0, finalCount - maxCount)
    var g1 = source.lazy.enumerated().reversed().makeIterator() // Keep source index offset.
    var g2 = addition.lazy.enumerated().reversed().makeIterator() // Keep source index offset.
    var ms1 = [ArrayMutation<T>]()
    var ms2 = [ArrayMutation<T>]()
    var canContinue = true

    /// O(1) if array has slack on capacity.
    func pushDeleteMutation(sourceOffset d1: I) {
        let i = source.startIndex + d1
        let r = CountableRange(i..<(i + 1))
        let es = Array(source[r])
        let m = ArrayMutation.delete(range: r, elements: es)
        ms1.append(m)
    }
    /// O(1) if array has slack on capacity.
    func pushDeleteMutation(additionOffset d2: I) {
        let i = source.startIndex + d2
        let r = CountableRange(i..<(i + 1))
        let es = Array(addition[r])
        let m = ArrayMutation.delete(range: r, elements: es)
        ms2.append(m)
    }
    /// O(1) if array has slack on capacity.
    func step() {
        guard ms1.count + ms2.count < maxDeleteMutationCount else {
            canContinue = false
            return
        }
        let n1 = g1.eonil_getPreview()
        let n2 = g2.eonil_getPreview()
        
        if let n1 = n1, let n2 = n2 {
            if n1.element == n2.element {
                // No change number of element in final state. Just skip.
                g1.eonil_skip()
                g2.eonil_skip()
                return
            }
            if n1.element < n2.element {
                pushDeleteMutation(additionOffset: n2.offset)
                g2.eonil_skip()
                return
            }
            if n1.element > n2.element {
                pushDeleteMutation(sourceOffset: n1.offset)
                g1.eonil_skip()
                return
            }
            return
        }
        if let n1 = n1 {
            pushDeleteMutation(sourceOffset: n1.offset)
            g1.eonil_skip()
            return
        }
        if let n2 = n2 {
            pushDeleteMutation(additionOffset: n2.offset)
            g2.eonil_skip()
            return
        }

        // Consumed all elements from both arrays.
        canContinue = false
        return
    }
    while canContinue {
        step()
    }
    return (ms1, ms2)
}
