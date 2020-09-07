//
//  Faction.swift
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

public enum Faction: Int, CaseIterable {
    case demacia            = 0
    case freljord           = 1
    case ionia              = 2
    case noxus              = 3
    case piltoverZaun       = 4
    case shadowIsles        = 5
    case bilgewater         = 6
    case targon             = 9

    public var identifier: String {
        switch self {
        case .demacia:      return "DE"
        case .freljord:     return "FR"
        case .ionia:        return "IO"
        case .noxus:        return "NX"
        case .piltoverZaun: return "PZ"
        case .shadowIsles:  return "SI"
        case .bilgewater:   return "BW"
        case .targon:       return "MT"
        }
    }
    
    public init?(identifier: String) {
        guard let faction = Faction.allCases.first(where: { $0.identifier == identifier }) else { return nil }
        self = faction
    }
}
