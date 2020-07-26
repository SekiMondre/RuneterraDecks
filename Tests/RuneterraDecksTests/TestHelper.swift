//
//  TestHelper.swift
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

import Foundation

final class TestHelper {
    
    private enum Error: Swift.Error {
        case fileDoesNotExist(_ file: String, _ type: String)
    }

    static func loadDeckCodesTestData() throws -> [DeckStub] {
        try load([DeckStub].self, fromFile: "deckCodesTestData")
    }

    private static func load<T: Decodable>(_ type: T.Type, fromFile file: String, fileType: String = "json") throws -> T {
        guard let path = Bundle.module.path(forResource: file, ofType: fileType) else {
            throw Error.fileDoesNotExist(file, fileType)
        }
        return try decode(T.self, fromFileAt: path)
    }

    private static func decode<T: Decodable>(_ type: T.Type, fromFileAt path: String) throws -> T {
        let url = URL(fileURLWithPath: path)
        let fileData = try Data(contentsOf: url, options: .uncached)
        return try JSONDecoder().decode(T.self, from: fileData)
    }
}
