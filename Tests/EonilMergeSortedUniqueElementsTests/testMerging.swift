import XCTest
@testable import EonilMergeSortedUniqueElements

class TestMerging: XCTestCase {
    func testAll() {
        _ = {
            let a = [1,2,3]
            let b = [4,5,6]
            let ms = makeMergeMutations(source: a, addition: b)
            XCTAssert(ms.count == 3)
            XCTAssert(ms[0] == a.makeInsert(at: 3, value: b[2]))
            XCTAssert(ms[1] == a.makeInsert(at: 3, value: b[1]))
            XCTAssert(ms[2] == a.makeInsert(at: 3, value: b[0]))
        }()
        _ = {
            let a = [1,2,3]
            let b = [2,3,4]
            let ms = makeMergeMutations(source: a, addition: b)
            XCTAssert(ms.count == 3)
            XCTAssert(ms[0] == a.makeInsert(at: 3, value: 4))
            XCTAssert(ms[1] == a.makeUpdate(at: 2, value: 3))
            XCTAssert(ms[2] == a.makeUpdate(at: 1, value: 2))
        }()
        _ = {
            let a = [1,2,3]
            let b = [2,3,4]
            let ms = makeMergeMutations(source: a, addition: b, shouldUpdateSource: { _ in false })
            XCTAssert(ms.count == 1)
            XCTAssert(ms[0] == a.makeInsert(at: 3, value: 4))
        }()
        _ = {
            let a = [2,3,4]
            let b = [1,2,3]
            let ms = makeMergeMutations(source: a, addition: b)
            XCTAssert(ms.count == 3)
            XCTAssert(ms[0] == a.makeUpdate(at: 1, value: 3))
            XCTAssert(ms[1] == a.makeUpdate(at: 0, value: 2))
            XCTAssert(ms[2] == a.makeInsert(at: 0, value: 1))
        }()
    }
    static var allTests : [(String, (TestMerging) -> () throws -> Void)] {
        return [
            ("testAll", testAll),
        ]
    }
}

private extension Array {
    func makeInsert(at index: Int, value: Element) -> ArrayMutation<Element> {
        return .insert(index..<(index + 1), [value])
    }
    func makeUpdate(at index: Int, value: Element) -> ArrayMutation<Element> {
        return .update(index..<(index + 1), [value])
    }
}
