import XCTest

import RuneterraDecksTests

var tests = [XCTestCaseEntry]()
tests += Base32Tests.allTests()
tests += DeckCodingTests.allTests()
XCTMain(tests)
