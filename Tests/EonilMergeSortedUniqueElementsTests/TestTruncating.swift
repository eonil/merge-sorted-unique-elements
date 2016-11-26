import XCTest
@testable import EonilMergeSortedUniqueElements

class TestTruncating: XCTestCase {
    func testAll() {
        _ = {
            let a = [1,2,3]
            let b = [1,2,3]
            let (ms1, ms2) = makeTruncateLastMutations(source: a, addition: b, maxCount: 3)
            XCTAssert(ms1.count == 0)
            XCTAssert(ms2.count == 0)
        }()
        _ = {
            let a = [1,2,3]
            let b = [4,5,6]
            let (ms1, ms2) = makeTruncateLastMutations(source: a, addition: b, maxCount: 0)
            XCTAssert(ms1.count == 3)
            XCTAssert(ms2.count == 3)
            XCTAssert(ms1[0] == a.makeDelete(index: 2))
            XCTAssert(ms1[1] == a.makeDelete(index: 1))
            XCTAssert(ms1[2] == a.makeDelete(index: 0))
            XCTAssert(ms2[0] == b.makeDelete(index: 2))
            XCTAssert(ms2[1] == b.makeDelete(index: 1))
            XCTAssert(ms2[2] == b.makeDelete(index: 0))
        }()
        _ = {
            let a = [1,2,3]
            let b = [4,5,6]
            let (ms1, ms2) = makeTruncateLastMutations(source: a, addition: b, maxCount: 2)
            XCTAssert(ms1.count == 1)
            XCTAssert(ms2.count == 3)
            XCTAssert(ms1[0] == a.makeDelete(index: 2))
            XCTAssert(ms2[0] == b.makeDelete(index: 2))
            XCTAssert(ms2[1] == b.makeDelete(index: 1))
            XCTAssert(ms2[2] == b.makeDelete(index: 0))
        }()
        _ = {
            let a = [1,2,3]
            let b = [4,5,6]
            let (ms1, ms2) = makeTruncateLastMutations(source: a, addition: b, maxCount: 4)
            XCTAssert(ms1.count == 0)
            XCTAssert(ms2.count == 2)
            XCTAssert(ms2[0] == b.makeDelete(index: 2))
            XCTAssert(ms2[1] == b.makeDelete(index: 1))
        }()
        _ = {
            let a = [1,2,3]
            let b = [4,5,6]
            let (ms1, ms2) = makeTruncateLastMutations(source: a, addition: b, maxCount: 6)
            XCTAssert(ms1.count == 0)
            XCTAssert(ms2.count == 0)
        }()
        _ = {
            let a = [1,2,3]
            let b = [2,3,4]
            let (ms1, ms2) = makeTruncateLastMutations(source: a, addition: b, maxCount: 0)
            XCTAssert(ms1[0] == a.makeDelete(index: 0))
            XCTAssert(ms2[0] == b.makeDelete(index: 2))
        }()

        _ = {
            let a = [1,3,5]
            let b = [2,4,6]
            let (ms1, ms2) = makeTruncateLastMutations(source: a, addition: b, maxCount: 0)
            XCTAssert(ms1.count == 3)
            XCTAssert(ms2.count == 3)
            XCTAssert(ms2[0] == b.makeDelete(index: 2))
            XCTAssert(ms1[0] == a.makeDelete(index: 2))
            XCTAssert(ms2[1] == b.makeDelete(index: 1))
            XCTAssert(ms1[1] == a.makeDelete(index: 1))
            XCTAssert(ms2[2] == b.makeDelete(index: 0))
            XCTAssert(ms1[2] == a.makeDelete(index: 0))
        }()
        testLog("OK.")
    }
    static var allTests : [(String, (TestTruncating) -> () throws -> Void)] {
        return [
            ("testAll", testAll),
        ]
    }
}



/// Operations are valid only in this file.
private extension Array {
    func makeInsert(index: Int) -> ArrayMutation<Element> {
        let r = index..<(index + 1)
        let es = Array(self[r])
        return .insert(range: r, elements: es)
    }
    func makeUpdate(index: Int) -> ArrayMutation<Element> {
        let r = index..<(index + 1)
        let es = Array(self[r])
        return .update(range: r, elements: es)
    }
    func makeDelete(index: Int) -> ArrayMutation<Element> {
        let r = index..<(index + 1)
        let es = Array(self[r])
        return .delete(range: r, elements: es)
    }
}

