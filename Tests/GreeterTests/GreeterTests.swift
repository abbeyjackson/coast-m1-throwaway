import XCTest
@testable import Greeter

/// Locks the acceptance criteria for Greeter.greet(name:) / greet().
final class GreeterTests: XCTestCase {
    func testGreetWithName() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: "Ada"), "Hello, Ada!")
    }

    func testGreetWithNoArguments() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(), "Hello, world!")
    }

    func testGreetWithEmptyName() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(name: ""), "Hello, !")
    }
}
