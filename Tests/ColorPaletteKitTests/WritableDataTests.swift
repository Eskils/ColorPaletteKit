//
//  WritableDataTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 11/10/2025.
//

import Foundation
import Testing
@testable import ColorPaletteKit

struct WritableDataTests {
    @Test
    func emptyInit() throws {
        let writable = WritableData()
        let readBytes = writable.bytes
        #expect(readBytes.isEmpty)
        #expect(writable.isEmpty)
    }
    
    @Test
    func initFromData() throws {
        let expectedBytes = (0..<Int.random(in: 4..<20)).map { _ in UInt8.random(in: 0..<255) }
        let data = Data(expectedBytes)
        let writable = WritableData(data: data)
        let readBytes = writable.bytes
        #expect(readBytes == expectedBytes)
    }
    
    @Test
    func count() throws {
        let threeBytes = WritableData(bytes: [0, 1, 2])
        #expect(threeBytes.count == 3)
        
        let oneByte = WritableData(bytes: [0])
        #expect(oneByte.count == 1)
        
        let empty = WritableData(bytes: [])
        #expect(empty.count == 0)
    }
    
    @Test
    func isEmpty() throws {
        let threeBytes = WritableData(bytes: [0, 1, 2])
        #expect(!threeBytes.isEmpty)
        
        let empty = WritableData(bytes: [])
        #expect(empty.isEmpty)
    }
    
    @Test
    func writeByte() throws {
        let expectedByte = UInt8.random(in: 4..<20)
        let writable = WritableData(bytes: [])
        writable.write(byte: expectedByte)
        #expect(writable.bytes == [expectedByte])
    }
    
    @Test
    func writeByteAtOffset() throws {
        let otherByte = UInt8.random(in: 4..<20)
        let expectedByte = UInt8.random(in: 4..<20)
        let writable = WritableData(bytes: [])
        writable.write(byte: otherByte)
        writable.write(byte: expectedByte)
        #expect(writable.bytes == [otherByte, expectedByte])
    }
    
    @Test
    func writeBytes() throws {
        let expectedBytes = (0..<Int.random(in: 2..<8))
            .map { _ in UInt8.random(in: 4..<20) }
        let writable = WritableData(bytes: [])
        writable.write(bytes: expectedBytes)
        #expect(writable.bytes == expectedBytes)
    }
    
    @Test
    func writeBytesAtOffset() throws {
        let otherByte = UInt8.random(in: 4..<20)
        let expectedBytes = (0..<Int.random(in: 2..<8))
            .map { _ in UInt8.random(in: 4..<20) }
        let writable = WritableData(bytes: [])
        writable.write(byte: otherByte)
        writable.write(bytes: expectedBytes)
        #expect(writable.bytes == [otherByte] + expectedBytes)
    }
    
    @Test
    func writeSmallInt16() throws {
        let int8 = UInt8.random(in: 4..<200)
        let int16 = UInt16(int8)
        let expectedBytes = [0, int8]
        let writable = WritableData(bytes: [])
        writable.write(int16: int16)
        #expect(writable.bytes == expectedBytes)
    }
    
    @Test
    func writeLargeInt16() throws {
        let firstByte = UInt8.random(in: 4..<200)
        let secondByte = UInt8.random(in: 4..<200)
        let int16 = UInt16(firstByte) << 8 + UInt16(secondByte)
        let expectedBytes = [firstByte, secondByte]
        let writable = WritableData(bytes: [])
        writable.write(int16: int16)
        #expect(writable.bytes == expectedBytes)
    }
    
    @Test
    func writeLargestInt16() throws {
        let int16 = UInt16.max
        let expectedBytes = [UInt8.max, UInt8.max]
        let writable = WritableData(bytes: [])
        writable.write(int16: int16)
        #expect(writable.bytes == expectedBytes)
    }
    
    @Test
    func writeSmallInt32() throws {
        let int8 = UInt8.random(in: 4..<200)
        let int32 = UInt32(int8)
        let expectedBytes = [0, 0, 0, int8]
        let writable = WritableData(bytes: [])
        writable.write(int32: int32)
        #expect(writable.bytes == expectedBytes)
    }
    
    @Test
    func writeLargeInt32() throws {
        let firstByte = UInt8.random(in: 4..<200)
        let secondByte = UInt8.random(in: 4..<200)
        let thirdByte = UInt8.random(in: 4..<200)
        let fourthByte = UInt8.random(in: 4..<200)
        let int32 = UInt32(firstByte) << 24
            + UInt32(secondByte) << 16
            + UInt32(thirdByte) << 8
            + UInt32(fourthByte)
        let expectedBytes = [firstByte, secondByte, thirdByte, fourthByte]
        let writable = WritableData(bytes: [])
        writable.write(int32: int32)
        #expect(writable.bytes == expectedBytes)
    }
    
    @Test
    func writeLargestInt32() throws {
        let int32 = UInt32.max
        let expectedBytes = [UInt8.max, UInt8.max, UInt8.max, UInt8.max]
        let writable = WritableData(bytes: [])
        writable.write(int32: int32)
        #expect(writable.bytes == expectedBytes)
    }
    
    @Test
    func writeUTF8WithDefaultRepresentation() throws {
        let writable = WritableData(bytes: [])
        writable.writeUTF8(string: "ABC ")
        #expect(writable.bytes == [65, 66, 67, 32])
    }
    
    @Test
    func writeUTF8WithContentRepresentation() throws {
        let writable = WritableData(bytes: [])
        writable.writeUTF8(string: "ABC ", representation: .content)
        #expect(writable.bytes == [65, 66, 67, 32])
    }
    
    @Test
    func writeUTF8WithNullTerminatedRepresentation() throws {
        let writable = WritableData(bytes: [])
        writable.writeUTF8(string: "ABC ", representation: .nullTerminated)
        #expect(writable.bytes == [65, 66, 67, 32, 0])
    }
    
    @Test
    func writeUTF8WithLengthPrefixedRepresentation() throws {
        let writable = WritableData(bytes: [])
        writable.writeUTF8(string: "ABC ", representation: .lengthPrefixed)
        #expect(writable.bytes == [0, 4, 65, 66, 67, 32])
    }
    
    @Test
    func writeUTF8WithLengthPrefixedAndNullTerminatedRepresentation() throws {
        let writable = WritableData(bytes: [])
        writable.writeUTF8(string: "ABC ", representation: [.lengthPrefixed, .nullTerminated])
        #expect(writable.bytes == [0, 5, 65, 66, 67, 32, 0])
    }
    
    @Test
    func writeUT168WithDefaultRepresentation() throws {
        let writable = WritableData(bytes: [])
        writable.writeUTF16(string: "ABC ")
        #expect(writable.bytes == [0, 65, 0, 66, 0, 67, 0, 32])
    }
    
    @Test
    func writeUTF16WithContentRepresentation() throws {
        let writable = WritableData(bytes: [])
        writable.writeUTF16(string: "ABC ", representation: .content)
        #expect(writable.bytes == [0, 65, 0, 66, 0, 67, 0, 32])
    }
    
    @Test
    func writeUTF16WithNullTerminatedRepresentation() throws {
        let writable = WritableData(bytes: [])
        writable.writeUTF16(string: "ABC ", representation: .nullTerminated)
        #expect(writable.bytes == [0, 65, 0, 66, 0, 67, 0, 32, 0])
    }
    
    @Test
    func writeUTF16WithLengthPrefixedRepresentation() throws {
        let writable = WritableData(bytes: [])
        writable.writeUTF16(string: "ABC ", representation: .lengthPrefixed)
        #expect(writable.bytes == [0, 4, 0, 65, 0, 66, 0, 67, 0, 32])
    }
    
    @Test
    func writeUTF16WithLengthPrefixedAndNullTerminatedRepresentation() throws {
        let writable = WritableData(bytes: [])
        writable.writeUTF16(string: "ABC ", representation: [.lengthPrefixed, .nullTerminated])
        #expect(writable.bytes == [0, 5, 0, 65, 0, 66, 0, 67, 0, 32, 0])
    }
}
