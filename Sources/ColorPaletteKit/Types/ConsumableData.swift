//
//  ConsumableData.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 05/10/2025.
//

import Foundation

class ConsumableData {
    private let bytes: [UInt8]
    private(set) var index: Int = 0
    
    var count: Int {
        bytes.count
    }
    
    var isEmpty: Bool {
        bytes.isEmpty
    }
    
    init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    func consumeByte() -> UInt8? {
        defer {
            safelyIncrementIndex(by: 1)
        }
        return readNextByte()
    }
    
    func consume(bytes numberOfBytes: Int) -> ArraySlice<UInt8> {
        defer {
            safelyIncrementIndex(by: numberOfBytes)
        }
        return readNext(bytes: numberOfBytes)
    }
    
    func skipByte() {
        safelyIncrementIndex(by: 1)
    }
    
    func skip(bytes numberOfBytes: Int) {
        safelyIncrementIndex(by: numberOfBytes)
    }
    
    func readNextByte() -> UInt8? {
        readNext(bytes: 1).first
    }
    
    func readNext(bytes numberOfBytes: Int) -> ArraySlice<UInt8> {
        let lowerBound = max(index, bytes.indices.lowerBound)
        let upperBound = min(index + numberOfBytes, bytes.indices.upperBound)
        guard upperBound > lowerBound else {
            return []
        }
        return bytes[lowerBound..<upperBound]
    }
    
    private func safelyIncrementIndex(by step: Int) {
        let incrementedIndex = index + step
        let clampedIncrementedIndex = min(incrementedIndex, bytes.indices.upperBound)
        index = clampedIncrementedIndex
    }
}

extension ConsumableData {
    convenience init(data: Data) {
        self.init(bytes: [UInt8](data))
    }
}
