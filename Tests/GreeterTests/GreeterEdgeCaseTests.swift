import XCTest
@testable import Greeter

/// Edge-case coverage for Greeter.greet(name:) / greet() below the plan's
/// resolution: unusual inputs and internal behavior not locked by the
/// acceptance criteria in GreeterTests.swift.
final class GreeterEdgeCaseTests: XCTestCase {
    func testGreetWithWhitespaceOnlyName() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "   "), "Hello,    !")
    }

    func testGreetWithLeadingAndTrailingWhitespace() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "  Ada  "), "Hello,   Ada  !")
    }

    func testGreetWithUnicodeName() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "Ünïcödé 🎉"), "Hello, Ünïcödé 🎉!")
    }

    func testGreetWithNewlineInName() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "Ada\nLovelace"), "Hello, Ada\nLovelace!")
    }

    func testGreetWithQuotesAndBackslashesInName() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "\"Ada\" \\Lovelace\\"), "Hello, \"Ada\" \\Lovelace\\!")
    }

    func testGreetWithVeryLongName() {
        let greeter = Greeter()
        let longName = String(repeating: "A", count: 10_000)
        XCTAssertEqual(greeter.greet(name: longName), "Hello, \(longName)!")
    }

    func testGreetWithNameContainingExclamationMark() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "Ada!"), "Hello, Ada!!")
    }

    func testGreetIsPureAndRepeatable() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "Ada"), greeter.greet(name: "Ada"))
        XCTAssertEqual(greeter.greet(), greeter.greet())
    }

    func testMultipleInstancesBehaveIdentically() {
        let first = Greeter()
        let second = Greeter()
        XCTAssertEqual(first.greet(name: "Ada"), second.greet(name: "Ada"))
        XCTAssertEqual(first.greet(), second.greet())
    }

    func testGreetWithNoArgumentsIsUnaffectedByPriorNamedCalls() {
        let greeter = Greeter()
        _ = greeter.greet(name: "Something Else")
        XCTAssertEqual(greeter.greet(), "Hello, world!")
    }
}
