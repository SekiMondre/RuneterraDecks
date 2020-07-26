//
//  DeckDecoder.swift
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

public enum DeckDecodingError: Error {
    case noInput
    case invalidBase32String
    case versionMismatch
    case inconsistentData
}

public struct DeckDecoder {
    
    private static let maxKnownVersion = 2
    
    public static func decode(_ deckCode: String) throws -> [Entry] {
        guard !deckCode.isEmpty else {
            throw DeckDecodingError.noInput
        }
        guard let data = Data(base32Encoded: deckCode), !data.isEmpty else {
            throw DeckDecodingError.invalidBase32String
        }
        
        let bytes = Array<UInt8>(data)
        let _ = bytes[0] >> 4 // Format info is still unused officially
        let version = bytes[0] & 0x0F
        
        if version > Self.maxKnownVersion {
            throw DeckDecodingError.versionMismatch
        }
        
        let varIntList = parseVarInts(Array(bytes.suffix(from: 1)))
        return try getCardEntries(from: varIntList)
    }
    
    private static func getCardEntries(from varIntList: [UInt]) throws -> [Entry] {
        var varInts = varIntList
        var deckCards: [Entry] = []
        
        // Decode cards with copy count of 3 or less
        for copyCount in (1...3).reversed() {
            guard !varInts.isEmpty else {
                throw DeckDecodingError.inconsistentData
            }
            
            let numberOfGroups = varInts.removeFirst()
            for _ in 0..<numberOfGroups {
                guard varInts.count >= 3 else {
                    throw DeckDecodingError.inconsistentData
                }
                
                let numberOfCards   = varInts[0]
                let setIndex        = varInts[1]
                let factionIndex    = varInts[2]
                varInts.removeFirst(3)
                
                guard let factionIdentifier = Faction(rawValue: Int(factionIndex))?.identifier else {
                    throw DeckDecodingError.inconsistentData
                }
                guard varInts.count >= numberOfCards else {
                    throw DeckDecodingError.inconsistentData
                }
                
                for _ in 0..<numberOfCards {
                    let cardNumber = varInts.removeFirst()
                    let cardcode = String(format: "%02d%@%03d", setIndex, factionIdentifier, cardNumber)
                    deckCards.append(Entry(cardCode: cardcode, count: copyCount))
                }
            }
        }
        
        // Decode special case of cards with count of 4 or greater
        while !varInts.isEmpty {
            guard varInts.count >= 4 else {
                throw DeckDecodingError.inconsistentData
            }
            let count   = Int(varInts[0])
            let set     = varInts[1]
            let faction = varInts[2]
            let number  = varInts[3]
            varInts.removeFirst(4)
            
            guard let factionIdentifier = Faction(rawValue: Int(faction))?.identifier else {
                throw DeckDecodingError.inconsistentData
            }
            
            let cardcode = String(format: "%02d%@%03d", set, factionIdentifier, number)
            deckCards.append(Entry(cardCode: cardcode, count: count))
            
        }
        
        return deckCards
    }
    
    private static func parseVarInts(_ bytes: [UInt8]) -> [UInt] {
        
        var integers: [UInt] = []
        
        var varInt: UInt = 0
        var index: UInt = 0
        for byte in bytes {
            varInt |= UInt(byte & 0x7F) << (index * 7)
            
            if byte & 0x80 == 0 {
                integers.append(varInt)
                varInt = 0
                index = 0
            } else {
                index += 1
            }
        }
        return integers
    }
}
