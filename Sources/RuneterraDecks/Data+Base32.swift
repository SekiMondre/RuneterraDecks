//
//  Data+Base32.swift
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

// MARK: Base32 Functions

private let base32Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

extension CharacterSet {
    
    static var base32: CharacterSet {
        CharacterSet(charactersIn: String(base32Alphabet))
    }
}

extension StringProtocol {
    
    var characters: [Character] {
        map { Character(String($0)) }
    }
    
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

private func base32Encode(_ data: Data) -> String {
    
    func mapBase32(_ value: UInt8) -> Character { base32Alphabet[Int(value)] }
    
    return stride(from: 0, to: data.count, by: 5).map { strideIndex -> String in
        
        let byteCount = strideIndex + 4 >= data.count ? data.count - strideIndex : 5
        let bytes = (0..<5).map { $0 < byteCount ? data[strideIndex + $0] : 0 }
        var encodedBlock = Array<Character>(repeating: "=", count: 8)
        
        switch byteCount {
        case 5:
            encodedBlock[7] = mapBase32(bytes[4] & 0x1F)
            fallthrough
        case 4:
            encodedBlock[6] = mapBase32((bytes[3] & 0x03) << 3 | bytes[4] >> 5)
            encodedBlock[5] = mapBase32(bytes[3] >> 2 & 0x1F)
            fallthrough
        case 3:
            encodedBlock[4] = mapBase32((bytes[2] & 0x0F) << 1 | bytes[3] >> 7)
            fallthrough
        case 2:
            encodedBlock[3] = mapBase32((bytes[1] & 0x01) << 4 | bytes[2] >> 4)
            encodedBlock[2] = mapBase32(bytes[1] >> 1 & 0x1F)
            fallthrough
        default:
            encodedBlock[1] = mapBase32((bytes[0] & 0x07) << 2 | bytes[1] >> 6)
            encodedBlock[0] = mapBase32(bytes[0] >> 3)
        }
        return String(encodedBlock)
    }.joined()
}

private func base32Decode(_ base32String: String) -> Data? {
    guard CharacterSet(charactersIn: base32String).isSubset(of: .base32) else { return nil }
    
    let buffer = stride(from: 0, to: base32String.count, by: 8).flatMap { strideIndex -> [UInt8] in
        let charCount = strideIndex + 7 >= base32String.count ? base32String.count - strideIndex : 8
        let outputCount = charCount > 7 ? 5 : (charCount > 5 ? 4 : (charCount > 4 ? 3 : (charCount > 2 ? 2 : 1)))
        
        let vals = (0..<8)
            .map { $0 < charCount ? base32String[strideIndex + $0] : Character("\0") }
            .map { UInt8(base32Alphabet.characters.firstIndex(of: $0) ?? 0) }
        
        var block = Array<UInt8>(repeating: 0, count: 5)
        block[0] = vals[0] << 3 | vals[1] >> 2
        block[1] = vals[1] << 6 | vals[2] << 1 | vals[3] >> 4
        block[2] = vals[3] << 4 | vals[4] >> 1
        block[3] = vals[4] << 7 | vals[5] << 2 | vals[6] >> 3
        block[4] = vals[6] << 5 | vals[7]
        return Array(block.prefix(outputCount))
    }
    return Data(bytes: buffer, count: buffer.count)
}

// MARK: Data Base32 Decoding

extension Data {
    
    struct Base32DecodingOptions: OptionSet {
        var rawValue: Int
        
        static let acceptLowercaseCharacters = Base32DecodingOptions(rawValue: 1 << 0)
        static let ignoreUnknownCharacters = Base32DecodingOptions(rawValue: 1 << 1)
    }
    
    init?(base32Encoded base32String: String, options: Data.Base32DecodingOptions = []) {
        var preprocessedString = base32String.replacingOccurrences(of: "=", with: "")
        
        if options.contains(.acceptLowercaseCharacters) {
            preprocessedString = preprocessedString.uppercased()
        }
        if options.contains(.ignoreUnknownCharacters) {
            preprocessedString = String(preprocessedString.unicodeScalars.filter { CharacterSet.base32.contains($0) })
        }
        
        guard let data = base32Decode(preprocessedString) else { return nil }
        self = data
    }
}

// MARK: Data Base32 Encoding

extension Data {
    
    struct Base32EncodingOptions: OptionSet {
        var rawValue: Int
        
        static let addPaddingCharacters = Base32EncodingOptions(rawValue: 1 << 0)
    }
    
    func base32EncodedString(options: Data.Base32EncodingOptions = []) -> String {
        let encoded = base32Encode(self)
        return options.contains(.addPaddingCharacters) ? encoded : encoded.replacingOccurrences(of: "=", with: "")
    }
}
