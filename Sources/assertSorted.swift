//
//  assertSorted.swift
//  DiffOnUniqueSortedArray
//
//  Created by Hoon H. on 2016/11/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

///
/// Checks whether the collection `a` is sorted in ascending order.
///
func assertSorted<C>(_ a: C) where C: RandomAccessCollection, C.Iterator.Element: Comparable {
    assert(Array(a.sorted(by: <)) == Array(a))
}
