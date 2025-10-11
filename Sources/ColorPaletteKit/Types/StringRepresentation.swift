//
//  StringRepresentation.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 11/10/2025.
//

struct StringRepresentation: OptionSet, Sendable {
    let rawValue: UInt8
    
    init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    var count: Int {
        self.rawValue.nonzeroBitCount
    }
}

extension StringRepresentation {
    /// Only the content of the string is written.
    static let content = Self(rawValue: 1 << 0)
    
    /// The length of the string is written before the content of the string itself.
    static let lengthPrefixed = Self(rawValue: 1 << 1)
    
    /// A null-character is written after the content of the string to indicate the end.
    static let nullTerminated = Self(rawValue: 1 << 2)
}

extension StringRepresentation {
    func contentLength(of string: String) -> Int {
        let count = string.count
        
        return if self.contains(.nullTerminated) {
            count + 1
        } else {
            count
        }
    }
}
