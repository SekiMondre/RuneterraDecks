import XCTest
@testable import RuneterraDecks

final class RuneterraDecksTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RuneterraDecks().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
