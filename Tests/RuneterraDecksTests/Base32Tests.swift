//
//  Base32Tests.swift
//
//  Copyright (c) 2020 André Vants
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import XCTest
@testable import RuneterraDecks

private extension String {
    var asciiData: Data {
        data(using: .ascii)!
    }
}

final class Base32Tests: XCTestCase {
        
    static var allTests = [
        ("testEncodeEmptyData", testEncodeEmptyData),
        ("testEncodeBase32",    testEncodeBase32),
        ("testEncodeAllBytes",  testEncodeAllBytes),
        ("testDecodeEmpty",     testDecodeEmpty),
        ("testDecodeBase32",    testDecodeBase32),
        ("testDecodeOptions",   testDecodeOptions),
    ]
    
    private func assertEncoding(_ data: Data, _ expected: String, padding: Bool = false) {
        XCTAssertEqual(data.base32EncodedString(options: padding ? [.addPaddingCharacters] : []), expected)
    }
    
    // MARK: Encode Tests
    
    func testEncodeEmptyData() {
        XCTAssertEqual(Data().base32EncodedString(), "")
    }
    
    func testEncodeBase32() {
        assertEncoding("a".asciiData,       "ME")
        assertEncoding("ab".asciiData,      "MFRA")
        assertEncoding("abc".asciiData,     "MFRGG")
        assertEncoding("abcd".asciiData,    "MFRGGZA")
        assertEncoding("abcde".asciiData,   "MFRGGZDF")
        
        assertEncoding("a".asciiData,       "ME======", padding: true)
        assertEncoding("ab".asciiData,      "MFRA====", padding: true)
        assertEncoding("abc".asciiData,     "MFRGG===", padding: true)
        assertEncoding("abcd".asciiData,    "MFRGGZA=", padding: true)
        assertEncoding("abcde".asciiData,   "MFRGGZDF", padding: true)
        
        assertEncoding("foobar".asciiData,  "MZXW6YTBOI======", padding: true)
    }
    
    func testEncodeAllBytes() {
        let allBytes = Data((0...255).map { UInt8($0) })
        let encoded = allBytes.base32EncodedString()
        let base32Decoded = Data(base32Encoded: encoded)
        XCTAssertEqual(allBytes, base32Decoded)
    }
    
    // MARK: Decode Tests
    
    func testDecodeEmpty() {
        XCTAssertEqual(Data(base32Encoded: ""), Data())
    }
    
    func testDecodeBase32() {
        XCTAssertEqual(Data(base32Encoded: "ME"),       "a".asciiData)
        XCTAssertEqual(Data(base32Encoded: "MFRA"),     "ab".asciiData)
        XCTAssertEqual(Data(base32Encoded: "MFRGG"),    "abc".asciiData)
        XCTAssertEqual(Data(base32Encoded: "MFRGGZA"),  "abcd".asciiData)
        XCTAssertEqual(Data(base32Encoded: "MFRGGZDF"), "abcde".asciiData)
        
        XCTAssertEqual(Data(base32Encoded: "ME======"), "a".asciiData)
        XCTAssertEqual(Data(base32Encoded: "MFRA===="), "ab".asciiData)
        XCTAssertEqual(Data(base32Encoded: "MFRGG==="), "abc".asciiData)
        XCTAssertEqual(Data(base32Encoded: "MFRGGZA="), "abcd".asciiData)
        XCTAssertEqual(Data(base32Encoded: "MFRGGZDF"), "abcde".asciiData)
    }
    
    func testDecodeOptions() {
        let undecodedLowercase = Data(base32Encoded: "mfrggzdf")
        let acceptLowercase = Data(base32Encoded: "mfrggzdf", options: .acceptLowercaseCharacters)
        XCTAssertNil(undecodedLowercase)
        XCTAssertEqual(acceptLowercase, "abcde".asciiData)
        
        let undecodedUnknown = Data(base32Encoded: "M@F\nR#$G  G+=Z\t$DF")
        let ignoreUnknown = Data(base32Encoded: "M@F\nR#$G  G+=Z\t$DF", options: .ignoreUnknownCharacters)
        XCTAssertNil(undecodedUnknown)
        XCTAssertEqual(ignoreUnknown, "abcde".asciiData)
    }
}

