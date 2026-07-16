import XCTest
@testable import Greeter

/// Post-work unit tests (D24): edge cases and internal behavior for
/// `Greeter` that sit below the plan's resolution. These do not lock new
/// requirements — they exercise unusual inputs and internal consistency of
/// the existing implementation.
final class GreeterEdgeCaseTests: XCTestCase {

    func testGreetWithWhitespaceOnlyNamePreservesWhitespace() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "   "), "Hello,    !")
    }

    func testGreetWithNameContainingLeadingAndTrailingSpacesIsNotTrimmed() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "  Bob  "), "Hello,   Bob  !")
    }

    func testGreetWithUnicodeNameIncludingEmoji() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "🎉Zoë🎉"), "Hello, 🎉Zoë🎉!")
    }

    func testGreetWithNameContainingNewlineIsPassedThrough() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "Line1\nLine2"), "Hello, Line1\nLine2!")
    }

    func testGreetWithNameContainingQuotesAndBackslashesIsNotEscaped() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "\"Quo\\ted\""), "Hello, \"Quo\\ted\"!")
    }

    func testGreetWithVeryLongNameReturnsFullNameUntouched() {
        let greeter = Greeter()
        let longName = String(repeating: "a", count: 10_000)
        XCTAssertEqual(greeter.greet(name: longName), "Hello, \(longName)!")
    }

    func testGreetWithNameThatLooksLikeAnInterpolationTokenIsNotReinterpreted() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "\\(injected)"), "Hello, \\(injected)!")
    }

    func testGreetWithNameCalledRepeatedlyIsDeterministic() {
        let greeter = Greeter()
        let first = greeter.greet(name: "Repeat")
        let second = greeter.greet(name: "Repeat")
        XCTAssertEqual(first, second)
    }

    func testGreetWithNoArgumentsCalledRepeatedlyIsDeterministic() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(), greeter.greet())
    }

    func testTwoIndependentGreeterInstancesBehaveIdentically() {
        let a = Greeter()
        let b = Greeter()
        XCTAssertEqual(a.greet(name: "Same"), b.greet(name: "Same"))
        XCTAssertEqual(a.greet(), b.greet())
    }

    func testGreetWithNamedArgumentDoesNotAffectDefaultGreeting() {
        let greeter = Greeter()
        _ = greeter.greet(name: "SideEffect?")
        XCTAssertEqual(greeter.greet(), "Hello, world!")
    }
}
