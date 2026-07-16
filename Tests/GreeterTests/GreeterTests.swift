import XCTest
@testable import Greeter

/// Requirement tests locking the Greeter plan's acceptance criteria.
final class GreeterTests: XCTestCase {

    func testGreetWithNameReturnsPersonalizedGreeting() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "Alice"), "Hello, Alice!")
    }

    func testGreetWithNoArgumentsReturnsWorldGreeting() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(), "Hello, world!")
    }

    func testGreetWithEmptyNameReturnsGreetingWithEmptyName() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: ""), "Hello, !")
    }
}
