//
//  TestdriveViewController.swift
//  EonilMergeSortedUniqueElements
//
//  Created by Hoon H. on 2016/11/26.
//
//

import Foundation
import UIKit
import EonilMergeSortedUniqueElements

typealias TestItem = (id: TestItemID, state: TestItemState)
struct TestItemID {
    static var seed = 0
    let number: Int
    init() {
        TestItemID.seed += 1
        number = TestItemID.seed
    }
}
struct TestItemState {
    var priority = 0
}
struct TestViewState {
    var items = [TestItem]()
}
struct TestTransaction {
    var from: TestViewState
    var to: TestViewState
    var by: [ArrayMutation<TestItem>]
}

final class TestdriveViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private let collectionV = FlowLayoutCollectionView()
    private var localState = TestViewState()
    private var transactionQueue = [TestTransaction]()
    private var isPerformingTransition = false

    func process(_ transaction: TestTransaction) {
        transactionQueue.append(transaction)
        guard isPerformingTransition == false else { return }
        continueProcessingQueuedTransaction()
    }

    private func continueProcessingQueuedTransaction() {
        guard transactionQueue.count > 0 else { return }
        guard let firstTransaction = transactionQueue.first else { return }
        transactionQueue.removeFirst()
        localState = firstTransaction.from
        collectionV.reloadData()
        isPerformingTransition = true
        collectionV.performBatchUpdates({ [weak self] in
            guard let s = self else { return }
            s.localState = firstTransaction.to
            for m in firstTransaction.by {
                switch m {
                case .insert(let range, _):
                    let idxps = range.map({ IndexPath(item: $0, section: 0) })
                    s.collectionV.insertItems(at: idxps)
                case .update(let range, _):
                    let idxps = range.map({ IndexPath(item: $0, section: 0) })
                    s.collectionV.reloadItems(at: idxps)
                case .delete(let range, _):
                    let idxps = range.map({ IndexPath(item: $0, section: 0) })
                    s.collectionV.deleteItems(at: idxps)
                }
            }
        }, completion: { [weak self] isComplete in
            guard let s = self else { return }
            s.collectionV.reloadData()
            s.isPerformingTransition = false
            s.continueProcessingQueuedTransaction()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionV)
        collectionV.register(Cell1.self, forCellWithReuseIdentifier: "Cell1")
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionV.frame = view.bounds
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return localState.items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = localState.items[indexPath.item]
        let cell = collectionV.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath)
        if let cell1 = cell as? Cell1 {
            cell1.label.text = "\(data.id.number): \(data.state.priority)"
        }
        cell.contentView.backgroundColor = UIColor.white
        return cell
    }
}

private final class FlowLayoutCollectionView: UICollectionView {
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    @available(*,unavailable)
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        precondition(layout is UICollectionViewFlowLayout)
        super.init(frame: frame, collectionViewLayout: layout)
    }
    @available(*,unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var flowLayout: UICollectionViewFlowLayout {
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
}
private final class Cell1: UICollectionViewCell {
    let label = UILabel()
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 10)
        label.frame = contentView.bounds
    }
}
