//
//  DeckEncoder.swift
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

fileprivate extension Int {
    
    var asVarInt: [UInt8] {
        makeVarInt(UInt(self))
    }
    
    private func makeVarInt(_ number: UInt) -> [UInt8] {
        if number == 0 { return [0] }
        
        var octets: [UInt8] = []
        var value = number
        
        while value > 0 {
            var octet = UInt8(value & 0xFF) | 0x80
            value >>= 7
            if value == 0 {
                octet &= ~0x80
            }
            octets.append(octet)
        }
        return octets
    }
}

public enum DeckEncodingError: Error, Equatable {
    case badCardCount
    case invalidCardCode(Entry.ValidationError)
}

public struct DeckEncoder {
    
    public static func encode(_ cards: [Entry]) throws -> String {
        
        let formatAndVersion: UInt8 = 0b0001_0001
        
        var cardGroups: [[Entry.Components]] = [[],[],[],[]]
        do {
            try cards.forEach {
                if $0.count < 1 {
                    throw DeckEncodingError.badCardCount
                }
                cardGroups[$0.count < 4 ? $0.count : 0].append(try $0.getComponents())
            }
        } catch let error as Entry.ValidationError {
            throw DeckEncodingError.invalidCardCode(error)
        }
        
        let buffer = [formatAndVersion] + cardGroups.enumerated()
            .map {
                $0.offset == 0 ? encode4PlusCards($0.element.sorted { $0.code < $1.code }) : encodeCards(groupCards($0.element))
            }
            .reversed()
            .flatMap {$0}
        
        return Data(buffer).base32EncodedString()
    }
    
    private static func encode4PlusCards(_ cards: [Entry.Components]) -> [UInt8] {
        return cards.flatMap { [
            $0.count.asVarInt,
            $0.set.asVarInt,
            $0.faction.rawValue.asVarInt,
            $0.number.asVarInt
        ].flatMap {$0}
        }
    }
    
    private static func encodeCards(_ groups: [[Entry.Components]]) -> [UInt8] {
        return groups.count.asVarInt + groups.flatMap { [
            $0.count.asVarInt,
            ($0.first?.set ?? 0).asVarInt,
            ($0.first?.faction.rawValue ?? 0).asVarInt,
            $0.flatMap { $0.number.asVarInt }
        ].flatMap {$0}
        }
    }
    
    private static func groupCards(_ cards: [Entry.Components]) -> [[Entry.Components]] {
        return cards.reduce(into: [[Entry.Components]]()) { groups, card in
            if let groupIndex = groups.firstIndex(where: {
                $0.contains { $0.set == card.set && $0.faction == card.faction }
            }) {
                groups[groupIndex].append(card)
            } else {
                groups += [[card]]
            }
        }
        .map { $0.sorted { $0.code < $1.code }}
        .sorted { $0.count < $1.count }
    }
}
