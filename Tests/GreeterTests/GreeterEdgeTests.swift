import XCTest
@testable import Greeter

/// Post-work unit tests below plan resolution (D24).
final class GreeterEdgeTests: XCTestCase {
    func testGreetWithEmptyNameStillGreets() {
        XCTAssertEqual(Greeter().greet(name: ""), "Hello, !")
    }

    func testGreetIsPureAndRepeatable() {
        let greeter = Greeter()
        XCTAssertEqual(greeter.greet(), greeter.greet())
    }
}
