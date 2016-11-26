//
//  IteratorProtocol+eonil.swift
//  DiffOnUniqueSortedArray
//
//  Created by Hoon H. on 2016/11/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

extension IteratorProtocol {
    func eonil_getPreview() -> Element? {
        var copy = self
        return copy.next()
    }
    mutating func eonil_skip() {
        _ = next()
    }
}
