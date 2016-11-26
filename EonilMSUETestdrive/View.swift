//
//  View.swift
//  EonilMergeSortedUniqueElements
//
//  Created by Hoon H. on 2016/11/26.
//
//

import Foundation
import UIKit
import EonilMergeSortedUniqueElements

final class View {
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private let testdriveVC = TestdriveViewController()
    init() {
        let items = [TestItem]()
        let addition1 = makeItems1()
        let addition2 = makeItems2()
        func getPosition(_ a: TestItem) -> Int { return a.state.priority }

        let ms1 = makeMergeMutations(source: items.map(getPosition),
                                     addition: addition1.map(getPosition),
                                     replaceSourceValues: { r in Array(items[r]) },
                                     replaceAdditionValues: { r in Array(addition1[r]) },
                                     shouldUpdateSource: { _ in true })
        let items1 = items.eonil_applied(ms1)

        let ms2 = makeMergeMutations(source: items1.map(getPosition),
                                     addition: addition2.map(getPosition),
                                     replaceSourceValues: { r in Array(items1[r]) },
                                     replaceAdditionValues: { r in Array(addition2[r]) },
                                     shouldUpdateSource: { _ in true })
        let items2 = items1.eonil_applied(ms2)

        let vs0 = TestViewState(items: items)
        let vs1 = TestViewState(items: items1)
        let vs2 = TestViewState(items: items2)

        let t1 = TestTransaction(from: vs0,
                                 to: vs1,
                                 by: ms1)
        let t2 = TestTransaction(from: vs1,
                                 to: vs2,
                                 by: ms2)

        window.makeKeyAndVisible()
        window.rootViewController = testdriveVC

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) { [weak self] in
            guard let s = self else { return }
            s.testdriveVC.process(t1)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) { [weak self] in
            guard let s = self else { return }
            s.testdriveVC.process(t2)
        }
    }
}

private func makeItems1() -> [TestItem] {
    return [
        makeItem(priority: 10),
        makeItem(priority: 20),
        makeItem(priority: 30),
    ]
}
private func makeItems2() -> [TestItem] {
    return [
        makeItem(priority: 12),
        makeItem(priority: 20),
        makeItem(priority: 32),
    ]
}
private func makeItem(priority: Int) -> TestItem {
    return (TestItemID(), TestItemState(priority: priority))
}
private func makeItem(id: TestItemID, priority: Int) -> TestItem {
    return (id, TestItemState(priority: priority))
}


private let idPool: [TestItemID] = [
    TestItemID(),
    TestItemID(),
    TestItemID(),
    TestItemID(),
]
