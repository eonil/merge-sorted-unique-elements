//
//  TestUtility.swift
//  DiffOnUniqueSortedArray
//
//  Created by Hoon H. on 2016/11/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

@testable import EonilMergeSortedUniqueElements

func == <T: Equatable> (_ a: [ArrayMutation<T>], _ b: [ArrayMutation<T>]) -> Bool {
    guard a.count == b.count else { return false }
    for i in 0..<a.count {
        guard a[i] == b[i] else { return false }
    }
    return true
}
