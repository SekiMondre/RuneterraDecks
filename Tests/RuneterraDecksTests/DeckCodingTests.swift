//
//  DeckCodingTests.swift
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

struct DeckStub: Codable {
    
    private let cards: [String]
    let code: String
    
    var cardEntries: [Entry] {
        cards.map {
            let substrings = $0.split(separator: ":").map { String($0) }
            guard let count = Int(substrings[0]) else {
                fatalError("[DeckTestData] Deck card count test data is inconsistent.")
            }
            return Entry(cardCode: substrings[1], count: count)
        }
    }
}

final class DeckCodingTests: XCTestCase {
    
    static var allTests = [
        ("testRecommendedDecksCoding",              testRecommendedDecksCoding),
        ("testRecommendedDecksCodingReversed",      testRecommendedDecksCodingReversed),
        ("testCodingDeckSmall",                     testCodingDeckSmall),
        ("testCodingDeckLarge",                     testCodingDeckLarge),
        ("testCoding4PlusDeckSmall",                testCoding4PlusDeckSmall),
        ("testCoding4PlusDeckLarge",                testCoding4PlusDeckLarge),
        ("testSingleCard40Times",                   testSingleCard40Times),
        ("testWorstCaseLength",                     testWorstCaseLength),
        ("testOrderIsInconsequential",              testOrderIsInconsequential),
        ("testOrderIsInconsequential4Plus",         testOrderIsInconsequential4Plus),
        ("testOrderIsInconsequential4PlusExtra",    testOrderIsInconsequential4PlusExtra),
        ("testBilgewaterSet",                       testBilgewaterSet),
        ("testTargonSet",                           testTargonSet),
        ("testBadCardCount",                        testBadCardCount),
        ("testBadCardCodes",                        testBadCardCodes),
        ("testBadDeckDecoding",                     testBadDeckDecoding),
    ]

    // MARK: Support Functions
    
    private func encodeThenDecode(_ cards: [Entry]) throws -> [Entry] {
        let code = try DeckEncoder.encode(cards)
        let decoded = try DeckDecoder.decode(code)
        return decoded
    }
    
    private func assertCardsEqual(_ lhs: [Entry], _ rhs: [Entry]) {
        XCTAssert(Set(lhs) == Set(rhs))
    }
    
    // MARK: Recommended Decks Data Tests
    
    func testRecommendedDecksCoding() throws {
        let decks = try TestHelper.loadDeckCodesTestData()
        
        // Repeat to ensure encoding order consistency
        for _ in 1...10 {
            for deck in decks {
                let encoded = try DeckEncoder.encode(deck.cardEntries)
                let decoded = try DeckDecoder.decode(encoded)
                
                XCTAssertEqual(deck.code, encoded)
                assertCardsEqual(deck.cardEntries, decoded)
            }
        }
    }
    
    func testRecommendedDecksCodingReversed() throws {
        let decks = try TestHelper.loadDeckCodesTestData()
        
        // Repeat to ensure encoding order consistency
        for _ in 1...10 {
            for deck in decks {
                let encoded = try DeckEncoder.encode(deck.cardEntries)
                let decoded = try DeckDecoder.decode(encoded)
                
                XCTAssertEqual(deck.code, encoded)
                assertCardsEqual(deck.cardEntries, decoded)
            }
        }
    }
    
    // MARK: Edge Cases Tests
    
    func testCodingDeckSmall() throws {
        let cards = [
            Entry(cardCode: "01DE002", count: 1)
        ]
        let decoded = try encodeThenDecode(cards)
        assertCardsEqual(cards, decoded)
    }
    
    func testCodingDeckLarge() throws {
        let cards = [
            Entry(cardCode: "01DE002", count: 3),
            Entry(cardCode: "01DE003", count: 3),
            Entry(cardCode: "01DE004", count: 3),
            Entry(cardCode: "01DE005", count: 3),
            Entry(cardCode: "01DE006", count: 3),
            Entry(cardCode: "01DE007", count: 3),
            Entry(cardCode: "01DE008", count: 3),
            Entry(cardCode: "01DE009", count: 3),
            Entry(cardCode: "01DE010", count: 3),
            Entry(cardCode: "01DE011", count: 3),
            Entry(cardCode: "01DE012", count: 3),
            Entry(cardCode: "01DE013", count: 3),
            Entry(cardCode: "01DE014", count: 3),
            Entry(cardCode: "01DE015", count: 3),
            Entry(cardCode: "01DE016", count: 3),
            Entry(cardCode: "01DE017", count: 3),
            Entry(cardCode: "01DE018", count: 3),
            Entry(cardCode: "01DE019", count: 3),
            Entry(cardCode: "01DE020", count: 3),
            Entry(cardCode: "01DE021", count: 3)
        ]
        let decoded = try encodeThenDecode(cards)
        assertCardsEqual(cards, decoded)
    }
    
    func testCoding4PlusDeckSmall() throws {
        let cards = [
            Entry(cardCode: "01DE002", count: 4)
        ]
        let decoded = try encodeThenDecode(cards)
        assertCardsEqual(cards, decoded)
    }
    
    func testCoding4PlusDeckLarge() throws {
        let cards = [
            Entry(cardCode: "01DE002", count: 3),
            Entry(cardCode: "01DE003", count: 3),
            Entry(cardCode: "01DE004", count: 3),
            Entry(cardCode: "01DE005", count: 3),
            Entry(cardCode: "01DE006", count: 4),
            Entry(cardCode: "01DE007", count: 5),
            Entry(cardCode: "01DE008", count: 6),
            Entry(cardCode: "01DE009", count: 7),
            Entry(cardCode: "01DE010", count: 8),
            Entry(cardCode: "01DE011", count: 9),
            Entry(cardCode: "01DE012", count: 3),
            Entry(cardCode: "01DE013", count: 3),
            Entry(cardCode: "01DE014", count: 3),
            Entry(cardCode: "01DE015", count: 3),
            Entry(cardCode: "01DE016", count: 3),
            Entry(cardCode: "01DE017", count: 3),
            Entry(cardCode: "01DE018", count: 3),
            Entry(cardCode: "01DE019", count: 3),
            Entry(cardCode: "01DE020", count: 3),
            Entry(cardCode: "01DE021", count: 3)
        ]
        let decoded = try encodeThenDecode(cards)
        assertCardsEqual(cards, decoded)
    }
    
    func testSingleCard40Times() throws {
        let cards = [
            Entry(cardCode: "01DE002", count: 40)
        ]
        let decoded = try encodeThenDecode(cards)
        assertCardsEqual(cards, decoded)
    }
    
    func testWorstCaseLength() throws {
        let cards = [
            Entry(cardCode: "01DE002", count: 4),
            Entry(cardCode: "01DE003", count: 4),
            Entry(cardCode: "01DE004", count: 4),
            Entry(cardCode: "01DE005", count: 4),
            Entry(cardCode: "01DE006", count: 4),
            Entry(cardCode: "01DE007", count: 5),
            Entry(cardCode: "01DE008", count: 6),
            Entry(cardCode: "01DE009", count: 7),
            Entry(cardCode: "01DE010", count: 8),
            Entry(cardCode: "01DE011", count: 9),
            Entry(cardCode: "01DE012", count: 4),
            Entry(cardCode: "01DE013", count: 4),
            Entry(cardCode: "01DE014", count: 4),
            Entry(cardCode: "01DE015", count: 4),
            Entry(cardCode: "01DE016", count: 4),
            Entry(cardCode: "01DE017", count: 4),
            Entry(cardCode: "01DE018", count: 4),
            Entry(cardCode: "01DE019", count: 4),
            Entry(cardCode: "01DE020", count: 4),
            Entry(cardCode: "01DE021", count: 4)
        ]
        let decoded = try encodeThenDecode(cards)
        assertCardsEqual(cards, decoded)
    }
    
    // MARK: Same Cards = Same Deck Tests
    
    func testOrderIsInconsequential() throws {
        let cardsA = [
            Entry(cardCode: "01DE002", count: 1),
            Entry(cardCode: "01DE003", count: 2),
            Entry(cardCode: "02DE003", count: 3)
        ]
        let cardsB = [
            Entry(cardCode: "01DE003", count: 2),
            Entry(cardCode: "02DE003", count: 3),
            Entry(cardCode: "01DE002", count: 1)
        ]

        let codeA = try DeckEncoder.encode(cardsA)
        let codeB = try DeckEncoder.encode(cardsB)
        XCTAssertEqual(codeA, codeB)
    }
    
    func testOrderIsInconsequential4Plus() throws {
        let cardsA = [
            Entry(cardCode: "01DE002", count: 4),
            Entry(cardCode: "01DE003", count: 2),
            Entry(cardCode: "02DE003", count: 3)
        ]
        let cardsB = [
            Entry(cardCode: "01DE003", count: 2),
            Entry(cardCode: "02DE003", count: 3),
            Entry(cardCode: "01DE002", count: 4)
        ]
        
        let codeA = try DeckEncoder.encode(cardsA)
        let codeB = try DeckEncoder.encode(cardsB)
        XCTAssertEqual(codeA, codeB)
    }
    
    func testOrderIsInconsequential4PlusExtra() throws {
        let cardsA = [
            Entry(cardCode: "01DE002", count: 4),
            Entry(cardCode: "01DE003", count: 2),
            Entry(cardCode: "02DE003", count: 3),
            Entry(cardCode: "01DE004", count: 5)
        ]
        let cardsB = [
            Entry(cardCode: "01DE004", count: 5),
            Entry(cardCode: "01DE003", count: 2),
            Entry(cardCode: "02DE003", count: 3),
            Entry(cardCode: "01DE002", count: 4)
        ]
        
        let codeA = try DeckEncoder.encode(cardsA)
        let codeB = try DeckEncoder.encode(cardsB)
        XCTAssertEqual(codeA, codeB)
    }
    
    // MARK: Expansion Set Tests
    
    func testBilgewaterSet() throws {
        let cards = [
            Entry(cardCode: "01DE002", count: 4),
            Entry(cardCode: "02BW003", count: 2),
            Entry(cardCode: "02BW010", count: 3),
            Entry(cardCode: "01DE004", count: 5)
        ]
        let decoded = try encodeThenDecode(cards)
        assertCardsEqual(cards, decoded)
    }

    func testTargonSet() throws {
        let cards = [
            Entry(cardCode: "01DE002", count: 4),
            Entry(cardCode: "02MT003", count: 2),
            Entry(cardCode: "02MT010", count: 3),
            Entry(cardCode: "01DE004", count: 5)
        ]
        let decoded = try encodeThenDecode(cards)
        assertCardsEqual(cards, decoded)
    }
    
    // MARK: Error Path Tests
    
    func testBadCardCount() {
        let cardsCountZero = [Entry(cardCode: "01DE002", count: 0)]
        
        XCTAssertThrowsError(try DeckEncoder.encode(cardsCountZero)) { error in
            XCTAssertEqual(error as? DeckEncodingError, DeckEncodingError.badCardCount)
        }
        
        let cardsCountNegative = [Entry(cardCode: "01DE002", count: -1)]
        
        XCTAssertThrowsError(try DeckEncoder.encode(cardsCountNegative)) { error in
            XCTAssertEqual(error as? DeckEncodingError, DeckEncodingError.badCardCount)
        }
    }
    
    // TODO: Test all error paths
    func testBadCardCodes() {
        let cardsBadLength = [Entry(cardCode: "01DE02", count: 1)]
        XCTAssertThrowsError(try DeckEncoder.encode(cardsBadLength)) { error in
            XCTAssertEqual(error as? DeckEncodingError, DeckEncodingError.invalidCardCode(.badLength))
        }
        
        let cardsBadFaction = [Entry(cardCode: "01XX002", count: 1)]
        XCTAssertThrowsError(try DeckEncoder.encode(cardsBadFaction)) { error in
            XCTAssertEqual(error as? DeckEncodingError, DeckEncodingError.invalidCardCode(.factionIdentifier))
        }
    }
    
    func testBadDeckDecoding() {
        let codeNotBase32 = "definitely not a card code!"
        let codeBadDeck = "ABCDEFG"
        let codeEmpty = ""
        
        XCTAssertThrowsError(try DeckDecoder.decode(codeNotBase32)) { error in
            XCTAssertEqual(error as? DeckDecodingError, DeckDecodingError.invalidBase32String)
        }
        XCTAssertThrowsError(try DeckDecoder.decode(codeBadDeck)) { error in
            XCTAssertEqual(error as? DeckDecodingError, DeckDecodingError.inconsistentData)
        }
        XCTAssertThrowsError(try DeckDecoder.decode(codeEmpty)) { error in
            XCTAssertEqual(error as? DeckDecodingError, DeckDecodingError.noInput)
        }
    }
}
