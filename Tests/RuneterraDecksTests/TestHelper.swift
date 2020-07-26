//
//  File.swift
//  
//
//  Created by André Vants Soares de Almeida on 26/07/20.
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
