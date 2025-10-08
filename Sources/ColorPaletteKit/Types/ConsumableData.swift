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
    
    func readInt16(mode: ReadMode) -> UInt16 {
        let bytes = read(mode: mode, bytes: 2)
        
        let firstByte = byte(at: 0, in: bytes, or: 0)
        let secondByte = byte(at: 1, in: bytes, or: 0)
        
        return UInt16(firstByte) << 8
            + UInt16(secondByte)
    }
    
    func readInt32(mode: ReadMode) -> UInt32 {
        let bytes = read(mode: mode, bytes: 4)
        
        let firstByte = byte(at: 0, in: bytes, or: 0)
        let secondByte = byte(at: 1, in: bytes, or: 0)
        let thirdByte = byte(at: 2, in: bytes, or: 0)
        let fourthByte = byte(at: 3, in: bytes, or: 0)
        
        return UInt32(firstByte) << 24
            + UInt32(secondByte) << 16
            + UInt32(thirdByte) << 8
            + UInt32(fourthByte)
    }
    
    func readASCII(of length: Int, mode: ReadMode) -> String {
        let bytes = read(mode: mode, bytes: length)
        let characters = bytes.map { Character(Unicode.Scalar($0)) }
        return String(characters)
    }
    
    func readUTF16(of length: Int, mode: ReadMode) -> String {
        let bytes = read(mode: mode, bytes: 2 * length)
        let readLength = bytes.count / 2
        let characters = (0..<readLength).compactMap { i -> Character? in
            let firstByte = bytes[2 * i]
            let secondByte = bytes[2 * i + 1]
            
            let scalar = UInt16(firstByte) << 8
                + UInt16(secondByte)
            
            guard let unicodeScalar = Unicode.Scalar(scalar) else {
                return nil
            }
            
            return Character(unicodeScalar)
        }
        return String(characters)
    }
    
    func read(mode: ReadMode, bytes numberOfBytes: Int) -> ArraySlice<UInt8> {
        switch mode {
        case .consume:
            consume(bytes: numberOfBytes)
        case .read:
            readNext(bytes: numberOfBytes)
        }
    }
    
    func readNextByte(mode: ReadMode) -> UInt8? {
        switch mode {
        case .consume:
            consumeByte()
        case .read:
            readNextByte()
        }
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
    
    private func byte(at index: Int, in bytes: ArraySlice<UInt8>, or trailing: UInt8) -> UInt8 {
        guard bytes.indices.contains(index) else {
            return trailing
        }
        
        return bytes[index]
    }
}

extension ConsumableData {
    convenience init(data: Data) {
        self.init(bytes: [UInt8](data))
    }
}
