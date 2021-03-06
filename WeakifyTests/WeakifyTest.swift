//  Copyright (c) 2015-2016 Kevin Lundberg. See LICENSE file for more info

import XCTest
import Weakify

private class Thing {}
private enum TestError: ErrorType { case Error }

class WeakifyTest: XCTestCase {

    private var object: Thing!
    var executed = false

    override func setUp() {
        super.setUp()

        object = Thing()
        executed = false
    }

    // MARK: - () -> Void

    func testVoidToVoidWillExecuteIfNotNil() {
        func f(object: Thing) -> () -> Void {
            return { self.executed = true }
        }

        weakify(object, f)()

        XCTAssertTrue(executed)
    }

    func testVoidThrowsToVoidWillExecuteIfNotNil() {
        func f(object: Thing) -> () throws -> Void {
            return { self.executed = true }
        }

        try! weakify(object, f)()

        XCTAssertTrue(executed)
    }

    func testVoidToVoidWillNotExecuteIfNil() {
        func f(object: Thing) -> () -> Void {
            return { self.executed = true }
        }

        let fn = weakify(object, f)
        object = nil
        fn()

        XCTAssertFalse(executed)
    }

    func testVoidThrowsToVoidWillNotExecuteIfNil() {
        func f(object: Thing) -> () throws -> Void {
            return { self.executed = true }
        }

        let fn = weakify(object, f)
        object = nil
        try! fn()

        XCTAssertFalse(executed)
    }

    func testVoidThrowsToVoidWillThrowIfNotNil() {
        func f(object: Thing) -> () throws -> Void {
            return { throw TestError.Error }
        }

        XCTAssertThrowsError(try weakify(object, f)())
    }

    // MARK: - U -> Void (ignoring U)

    func testUToVoidIgnoringUWillExecuteIfNotNil() {
        func f(object: Thing) -> () -> Void {
            return { self.executed = true }
        }

        let fn: Any -> Void = weakify(object, f)
        fn(123)

        XCTAssertTrue(executed)
    }

    func testUThrowsToVoidIgnoringUWillExecuteIfNotNil() {
        func f(object: Thing) -> () throws -> Void {
            return { self.executed = true }
        }

        let fn: Any throws -> Void = weakify(object, f)
        try! fn(123)

        XCTAssertTrue(executed)
    }

    func testUToVoidIgnoringUWillNotExecuteIfNil() {
        func f(object: Thing) -> () -> Void {
            return { self.executed = true }
        }

        let fn: Any -> Void = weakify(object, f)
        object = nil
        fn(123)

        XCTAssertFalse(executed)
    }

    func testUThrowsToVoidIgnoringUWillNotExecuteIfNil() {
        func f(object: Thing) -> () throws -> Void {
            return { self.executed = true }
        }

        let fn: Any throws -> Void = weakify(object, f)
        object = nil
        try! fn(123)

        XCTAssertFalse(executed)
    }

    func testUThrowsToVoidIgnoringUWillThrowIfNotNil() {
        func f(object: Thing) -> () throws -> Void {
            return { throw TestError.Error }
        }

        let fn: Any throws -> Void = weakify(object, f)

        XCTAssertThrowsError(try fn(123))
    }

    // MARK: - U -> Void

    func testUToVoidWillExecuteIfNotNil() {
        func f(object: Thing) -> (Int) -> Void {
            return { int in self.executed = true }
        }

        weakify(object, f)(123)

        XCTAssertTrue(executed)
    }

    func testUThrowsToVoidWillExecuteIfNotNil() {
        func f(object: Thing) -> (Int) throws -> Void {
            return { int in self.executed = true }
        }

        try! weakify(object, f)(123)

        XCTAssertTrue(executed)
    }

    func testUToVoidWillNotExecuteIfNil() {
        func f(object: Thing) -> (Int) -> Void {
            return { int in self.executed = true }
        }

        let fn = weakify(object, f)
        object = nil
        fn(123)

        XCTAssertFalse(executed)
    }

    func testUThrowsToVoidWillNotExecuteIfNil() {
        func f(object: Thing) -> (Int) throws -> Void {
            return { int in self.executed = true }
        }

        let fn = weakify(object, f)
        object = nil
        try! fn(123)

        XCTAssertFalse(executed)
    }

    func testUThrowsToVoidWillThrowIfNotNil() {
        func f(object: Thing) -> (Int) throws -> Void {
            return { _ in throw TestError.Error }
        }

        XCTAssertThrowsError(try weakify(object, f)(123))
    }

    // MARK: - () -> U

    func testVoidToUWillExecuteIfNotNil() {
        func f(object: Thing) -> () -> Int {
            return { return 123 }
        }

        XCTAssertEqual(123, weakify(object, f)())
    }

    func testVoidThrowsToUWillExecuteIfNotNil() {
        func f(object: Thing) -> () throws -> Int {
            return { return 123 }
        }

        XCTAssertEqual(123, try! weakify(object, f)())
    }

    func testVoidToUWillNotExecuteIfNil() {
        func f(object: Thing) -> () -> Int {
            return { return 123 }
        }

        let fn = weakify(object, f)
        object = nil
        XCTAssertEqual(nil, fn())
    }

    func testVoidThrowsToUWillNotExecuteIfNil() {
        func f(object: Thing) -> () throws -> Int {
            return { return 123 }
        }

        let fn = weakify(object, f)
        object = nil
        XCTAssertEqual(nil, try! fn())
    }


    func testVoidThrowsToUWillThrowIfNotNil() {
        func f(object: Thing) -> () throws -> Int {
            return { throw TestError.Error }
        }

        XCTAssertThrowsError(try weakify(object, f)())
    }

    // MARK: - U -> V

    func testUToVWillExecuteIfNotNil() {
        func f(object: Thing) -> (Int) -> String {
            return { int in return String(int) }
        }

        XCTAssertEqual("123", weakify(object, f)(123))
    }

    func testUThrowsToVWillExecuteIfNotNil() {
        func f(object: Thing) -> (Int) throws -> String {
            return { int in return String(int) }
        }

        XCTAssertEqual("123", try! weakify(object, f)(123))
    }

    func testUToVWillNotExecuteIfNil() {
        func f(object: Thing) -> (Int) -> String {
            return { int in return String(int) }
        }

        let fn = weakify(object, f)
        object = nil
        XCTAssertEqual(nil, fn(123))
    }

    func testUThrowsToVWillNotExecuteIfNil() {
        func f(object: Thing) -> (Int) throws -> String {
            return { int in return String(int) }
        }

        let fn = weakify(object, f)
        object = nil
        XCTAssertEqual(nil, try! fn(123))
    }


    func testUThrowsToVWillThrowIfNotNil() {
        func f(object: Thing) -> (Int) throws -> String {
            return { _ in throw TestError.Error }
        }

        XCTAssertThrowsError(try weakify(object, f)(123))
    }

    // MARK: - U as? V -> Void

    var value: Int?

    func testUasVWillExecuteIfNotNil() {
        func f(object: Thing) -> (Int?) -> Void {
            return { int in self.value = int; self.executed = true }
        }

        let fn: Any -> Void = weakify(object, f)
        fn(123)

        XCTAssertTrue(executed)
        XCTAssertEqual(123, value)
    }

    func testUasVThrowsWillExecuteIfNotNil() {
        func f(object: Thing) -> (Int?) throws -> Void {
            return { int in self.value = int; self.executed = true }
        }

        let fn: Any throws -> Void = weakify(object, f)
        try! fn(123)

        XCTAssertTrue(executed)
        XCTAssertEqual(123, value)
    }

    func testUasVWillGetNilIfParameterCannotBeCastAsU() {
        func f(object: Thing) -> (Int?) -> Void {
            return { int in self.value = int; self.executed = true }
        }

        weakify(object, f)("123")

        XCTAssertTrue(executed)
        XCTAssertEqual(nil, value)
    }

    func testUasVThrowsWillGetNilIfParameterCannotBeCastAsU() {
        func f(object: Thing) -> (Int?) throws -> Void {
            return { int in self.value = int; self.executed = true }
        }

        try! weakify(object, f)("123")

        XCTAssertTrue(executed)
        XCTAssertEqual(nil, value)
    }

    func testUasVWillNotExecuteIfNil() {
        func f(object: Thing) -> (Int?) -> Void {
            return { int in self.value = int; self.executed = true }
        }

        let fn: Any -> Void = weakify(object, f)
        object = nil
        fn("123")

        XCTAssertFalse(executed)
        XCTAssertEqual(nil, value)
    }

    func testUasVThrowsWillNotExecuteIfNil() {
        func f(object: Thing) -> (Int?) throws -> Void {
            return { int in self.value = int; self.executed = true }
        }

        let fn: Any throws -> Void = weakify(object, f)
        object = nil
        try! fn("123")

        XCTAssertFalse(executed)
        XCTAssertEqual(nil, value)
    }

    func testUasVThrowsWillThrowIfNotNil() {
        func f(object: Thing) -> (Int?) throws -> Void {
            return { _ in throw TestError.Error }
        }

        XCTAssertThrowsError(try weakify(object, f)("123"))
    }
}
