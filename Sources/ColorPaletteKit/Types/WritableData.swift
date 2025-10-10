//
//  WritableData.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 10/10/2025.
//

import Foundation

class WritableData {
    private var bytes: [UInt8]
    
    var count: Int {
        bytes.count
    }
    
    var isEmpty: Bool {
        bytes.isEmpty
    }
    
    init(bytes: [UInt8]) {
        self.bytes = bytes
    }
    
    @inline(__always)
    func write(byte: UInt8) {
        bytes.append(byte)
    }
    
    @inline(__always)
    func write(bytes: [UInt8]) {
        self.bytes += bytes
    }
    
    func write(int16: UInt16) {
        withUnsafePointer(to: int16) { int16Pointer in
            let int8Pointer = UnsafeRawPointer(int16Pointer)
                .assumingMemoryBound(to: UInt8.self)
            let firstByte = int8Pointer.pointee
            let secondByte = int8Pointer.advanced(by: 1).pointee
            write(bytes: [firstByte, secondByte])
        }
    }
    
    func write(int32: UInt32) {
        withUnsafePointer(to: int32) { int32Pointer in
            let int8Pointer = UnsafeRawPointer(int32Pointer)
                .assumingMemoryBound(to: UInt8.self)
            let firstByte = int8Pointer.pointee
            let secondByte = int8Pointer.advanced(by: 1).pointee
            let thirdByte = int8Pointer.advanced(by: 2).pointee
            let fourthByte = int8Pointer.advanced(by: 3).pointee
            write(bytes: [firstByte, secondByte, thirdByte, fourthByte])
        }
    }
    
    // FIXME: Implement: writeASCII, writeCString, writeUTF16
}

extension WritableData {
    convenience init(data: Data) {
        self.init(bytes: [UInt8](data))
    }
}
