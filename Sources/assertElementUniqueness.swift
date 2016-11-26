//
//  assertElementUniqueness.swift
//  DiffOnUniqueSortedArray
//
//  Created by Hoon H. on 2016/11/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

func assertElementUniqueness<C>(_ c: C) where C: RandomAccessCollection, C.Iterator.Element: Equatable {
    assert({ () -> Bool in
        let a = Array(c)
        for i in 0..<a.count {
            for j in 0..<a.count {
                if i == j { continue }
                if a[i] == a[j] { return false }
            }
        }
        return true
    }())
}
