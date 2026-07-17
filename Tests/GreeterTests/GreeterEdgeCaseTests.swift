import XCTest
@testable import Greeter

/// Edge-case coverage below the plan's resolution: unusual inputs to
/// `Greeter.greet(name:)` that the requirement tests don't exercise.
final class GreeterEdgeCaseTests: XCTestCase {
    func testGreetWithWhitespaceOnlyNameIsNotTrimmed() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "   "), "Hello,    !")
    }

    func testGreetWithLeadingAndTrailingWhitespaceIsPreserved() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "  Ava  "), "Hello,   Ava  !")
    }

    func testGreetWithUnicodeNameIsPreserved() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "José"), "Hello, José!")
    }

    func testGreetWithEmojiNameIsPreserved() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "🚀"), "Hello, 🚀!")
    }

    func testGreetWithSpecialCharactersIsNotEscaped() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "O'Brien & Co. \"The Best\""), "Hello, O'Brien & Co. \"The Best\"!")
    }

    func testGreetWithNewlineInNamePreservesNewline() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "Ava\nSmith"), "Hello, Ava\nSmith!")
    }

    func testGreetWithVeryLongNameReturnsFullGreeting() {
        let greeter = Greeter()
        let longName = String(repeating: "a", count: 10_000)
        let result = greeter.greet(name: longName)
        XCTAssertEqual(result, "Hello, \(longName)!")
        XCTAssertEqual(result.count, "Hello, ".count + longName.count + 1)
    }

    func testGreetWithNumericStringName() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "12345"), "Hello, 12345!")
    }
}
