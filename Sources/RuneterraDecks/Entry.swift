//
//  Entry.swift
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

public struct Entry: Hashable {
    
    public let cardCode: String
    public var count: Int
    
    public init(cardCode: String, count: Int) {
        self.cardCode = cardCode
        self.count = count
    }
}

extension Entry {
    
    public enum ValidationError: Error {
        case badLength
        case setIndex
        case factionIdentifier
        case cardNumber
    }
    
    struct Components {
        let count: Int
        let set: Int
        let faction: Faction
        let number: Int
        
        var code: String {
            String(format: "%02d%@%03d", set, faction.identifier, number)
        }
    }
    
    func getComponents() throws -> Components {
        guard cardCode.count == 7 else {
            throw ValidationError.badLength
        }
        guard let set = Int(cardCode[0...1]) else {
            throw ValidationError.setIndex
        }
        guard let faction = Faction(identifier: cardCode[2...3]) else {
            throw ValidationError.factionIdentifier
        }
        guard let number = Int(cardCode[4...]) else {
            throw ValidationError.cardNumber
        }
        return Components(count: count, set: set, faction: faction, number: number)
    }
}
