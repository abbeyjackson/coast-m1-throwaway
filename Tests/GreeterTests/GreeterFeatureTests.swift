import XCTest
@testable import Greeter

/// Requirement tests from the plan's acceptance criteria (D24 — red first).
final class GreeterFeatureTests: XCTestCase {
    func testGreetWithNameReturnsPersonalGreeting() {
        XCTAssertEqual(Greeter().greet(name: "Abbey"), "Hello, Abbey!")
    }

    func testGreetWithoutNameReturnsWorldGreeting() {
        XCTAssertEqual(Greeter().greet(), "Hello, world!")
    }
}
