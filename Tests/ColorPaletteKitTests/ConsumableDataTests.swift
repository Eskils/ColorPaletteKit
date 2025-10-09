//
//  ConsumableDataTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 05/10/2025.
//

import Foundation
import Testing
@testable import ColorPaletteKit

struct ConsumableDataTests {
    @Test
    func initFromData() throws {
        let expectedBytes = (0..<Int.random(in: 4..<20)).map { _ in UInt8.random(in: 0..<255) }
        let data = Data(expectedBytes)
        let consumable = ConsumableData(data: data)
        let readBytes = Array(consumable.readNext(bytes: consumable.count))
        #expect(readBytes == expectedBytes)
    }
    
    @Test
    func count() throws {
        let expectedCount = Int.random(in: 4..<20)
        let bytes = [UInt8](repeating: 0, count: expectedCount)
        let consumable = ConsumableData(bytes: bytes)
        #expect(consumable.count == expectedCount)
    }
    
    @Test(arguments: [1, 2, 0])
    func isEmpty(count: Int) throws {
        let bytes = [UInt8](repeating: 0, count: count)
        let consumable = ConsumableData(bytes: bytes)
        if count == 0 {
            #expect(consumable.isEmpty)
        } else {
            #expect(!consumable.isEmpty)
        }
    }
    
    @Test
    func readInt16ValueOfOne() throws {
        let consumable = ConsumableData(bytes: [0, 1])
        let int = consumable.readInt16(mode: .consume)
        #expect(int == 1)
        #expect(consumable.index == 2)
    }
    
    @Test
    func readTooShortInt16() throws {
        let consumable = ConsumableData(bytes: [1])
        let int = consumable.readInt16(mode: .consume)
        #expect(int == 256)
        #expect(consumable.index == 1)
    }
    
    @Test
    func readInt16ValueOf256() throws {
        let consumable = ConsumableData(bytes: [1, 0])
        let int = consumable.readInt16(mode: .read)
        #expect(int == 256)
        #expect(consumable.index == 0)
    }
    
    @Test
    func readInt16ValueAtOffset() throws {
        let consumable = ConsumableData(bytes: [0, 0, 1, 0])
        consumable.skip(bytes: 2)
        let int = consumable.readInt16(mode: .consume)
        #expect(int == 256)
        #expect(consumable.index == 4)
    }
    
    @Test
    func readInt32ValueOfOne() throws {
        let consumable = ConsumableData(bytes: [0, 0, 0, 1])
        let int = consumable.readInt32(mode: .consume)
        #expect(int == 1)
        #expect(consumable.index == 4)
    }
    
    @Test
    func readTooShortInt32() throws {
        let consumable = ConsumableData(bytes: [0, 1])
        let int = consumable.readInt32(mode: .consume)
        #expect(int == 65536)
        #expect(consumable.index == 2)
    }
    
    @Test
    func readInt32ValueOf256() throws {
        let consumable = ConsumableData(bytes: [0, 0, 1, 0])
        let int = consumable.readInt32(mode: .read)
        #expect(int == 256)
        #expect(consumable.index == 0)
    }
    
    @Test
    func readASCII() throws {
        let consumable = ConsumableData(bytes: [65, 66, 67, 68])
        let text = consumable.readASCII(of: 4, mode: .read)
        #expect(text == "ABCD")
        #expect(consumable.index == 0)
    }
    
    @Test
    func readTooShortASCII() throws {
        let consumable = ConsumableData(bytes: [65, 66])
        let text = consumable.readASCII(of: 4, mode: .consume)
        #expect(text == "AB")
        #expect(consumable.index == 2)
    }
    
    @Test
    func readUTF16() throws {
        let consumable = ConsumableData(bytes: [00, 65, 00, 66, 00, 67, 00, 68])
        let text = consumable.readUTF16(of: 4, mode: .read)
        #expect(text == "ABCD")
        #expect(consumable.index == 0)
    }
    
    @Test
    func readTooShortUTF16() throws {
        let consumable = ConsumableData(bytes: [00, 65, 00, 66])
        let text = consumable.readUTF16(of: 4, mode: .consume)
        #expect(text == "AB")
        #expect(consumable.index == 4)
    }
    
    @Test
    func readUTF16AtOffset() throws {
        let consumable = ConsumableData(bytes: [0, 0, 00, 65, 00, 66, 00, 67, 00, 68])
        consumable.skip(bytes: 2)
        let text = consumable.readUTF16(of: 4, mode: .read)
        #expect(text == "ABCD")
        #expect(consumable.index == 2)
    }
    
    @Test
    func readASCIIAsUTF16() throws {
        let consumable = ConsumableData(bytes: [65, 66, 67, 68])
        let text = consumable.readUTF16(of: 4, mode: .read)
        #expect(text == "䅂䍄")
        #expect(consumable.index == 0)
    }
    
    @Test
    func readNextByteReadMode() throws {
        let consumable = ConsumableData(bytes: [0, 1, 2, 3])
        let byte1 = consumable.readNextByte(mode: .read)
        #expect(byte1 == 0)
        #expect(consumable.index == 0)
        
        let byte2 = consumable.readNextByte(mode: .read)
        #expect(byte2 == 0)
    }
    
    @Test
    func readNextByteConsumeMode() throws {
        let consumable = ConsumableData(bytes: [0, 1, 2, 3])
        let byte1 = consumable.readNextByte(mode: .consume)
        #expect(byte1 == 0)
        #expect(consumable.index == 1)
        
        let byte2 = consumable.readNextByte(mode: .read)
        #expect(byte2 == 1)
    }
    
    @Test
    func readReadMode() throws {
        let consumable = ConsumableData(bytes: [0, 1, 2, 3])
        let byteSlice1 = consumable.read(mode: .read, bytes: 2)
        #expect(byteSlice1 == [0, 1])
        #expect(consumable.index == 0)
        
        let byte2 = consumable.readNextByte(mode: .read)
        #expect(byte2 == 0)
    }
    
    @Test
    func readConsumeMode() throws {
        let consumable = ConsumableData(bytes: [0, 1, 2, 3])
        let byteSlice1 = consumable.read(mode: .consume, bytes: 2)
        #expect(byteSlice1 == [0, 1])
        #expect(consumable.index == 2)
        
        let byte2 = consumable.readNextByte(mode: .read)
        #expect(byte2 == 2)
    }
    
    @Test
    func consumeByte() throws {
        let bytes = (0..<4).map { i in UInt8(i) }
        let consumable = ConsumableData(bytes: bytes)
        
        let byte1 = consumable.consumeByte()
        #expect(byte1 == 0)
        #expect(consumable.index == 1)
        
        let byte2 = consumable.consumeByte()
        #expect(byte2 == 1)
        #expect(consumable.index == 2)
        
        let byte3 = consumable.consumeByte()
        #expect(byte3 == 2)
        #expect(consumable.index == 3)
        
        let byte4 = consumable.consumeByte()
        #expect(byte4 == 3)
        #expect(consumable.index == 4)
        
        let outOfBoundsByte = consumable.consumeByte()
        #expect(outOfBoundsByte == nil)
        #expect(consumable.index == 4)
    }
    
    @Test
    func consumeByteEmptyData() throws {
        let consumable = ConsumableData(bytes: [])
        
        let byte1 = consumable.consumeByte()
        #expect(byte1 == nil)
        #expect(consumable.index == 0)
        
        let byte2 = consumable.consumeByte()
        #expect(byte2 == nil)
        #expect(consumable.index == 0)
    }
    
    @Test
    func readNextByte() throws {
        let bytes = (0..<4).map { i in UInt8(i) }
        let consumable = ConsumableData(bytes: bytes)
        
        let byte1 = consumable.readNextByte()
        #expect(byte1 == 0)
        #expect(consumable.index == 0)
        
        let byte2 = consumable.readNextByte()
        #expect(byte2 == 0)
        #expect(consumable.index == 0)
    }
    
    @Test
    func readNextByteEmptyData() throws {
        let consumable = ConsumableData(bytes: [])
        
        let byte1 = consumable.readNextByte()
        #expect(byte1 == nil)
        #expect(consumable.index == 0)
    }
    
    @Test
    func consumeBytes() throws {
        let bytes = (0..<4).map { i in UInt8(i) }
        let consumable = ConsumableData(bytes: bytes)
        
        let byteSlice1 = consumable.consume(bytes: 2)
        #expect(byteSlice1 == [0, 1])
        #expect(consumable.index == 2)
        
        let byteSlice2 = consumable.consume(bytes: 2)
        #expect(byteSlice2 == [2, 3])
        #expect(consumable.index == 4)
        
        let outOfBoundsByteSlice = consumable.consume(bytes: 2)
        #expect(outOfBoundsByteSlice == [])
        #expect(consumable.index == 4)
    }
    
    @Test
    func consumeBytesEmptyArray() throws {
        let consumable = ConsumableData(bytes: [])
        
        let byteSlice1 = consumable.consume(bytes: 2)
        #expect(byteSlice1 == [])
        #expect(consumable.index == 0)
    }
    
    @Test
    func consumeBytesClampsOverflowingNumberOfBytes() throws {
        let bytes = (0..<2).map { i in UInt8(i) }
        let consumable = ConsumableData(bytes: bytes)
        
        let byteSlice1 = consumable.consume(bytes: 4)
        #expect(byteSlice1 == [0, 1])
        #expect(consumable.index == 2)
    }
    
    @Test
    func readNextBytes() throws {
        let bytes = (0..<4).map { i in UInt8(i) }
        let consumable = ConsumableData(bytes: bytes)
        
        let byteSlice1 = consumable.readNext(bytes: 2)
        #expect(byteSlice1 == [0, 1])
        #expect(consumable.index == 0)
        
        let byteSlice2 = consumable.readNext(bytes: 2)
        #expect(byteSlice2 == [0, 1])
        #expect(consumable.index == 0)
    }
    
    @Test
    func readNextBytesEmptyArray() throws {
        let consumable = ConsumableData(bytes: [])
        
        let byteSlice1 = consumable.readNext(bytes: 2)
        #expect(byteSlice1 == [])
        #expect(consumable.index == 0)
    }
    
    @Test
    func readNextBytesClampsOverflowingNumberOfBytes() throws {
        let bytes = (0..<2).map { i in UInt8(i) }
        let consumable = ConsumableData(bytes: bytes)
        
        let byteSlice1 = consumable.readNext(bytes: 4)
        #expect(byteSlice1 == [0, 1])
        #expect(consumable.index == 0)
    }
    
    @Test
    func skipByte() throws {
        let bytes = (0..<4).map { i in UInt8(i) }
        let consumable = ConsumableData(bytes: bytes)
        try #require(consumable.index == 0)
        
        consumable.skipByte()
        #expect(consumable.index == 1)
        
        let byte1 = consumable.readNextByte()
        #expect(byte1 == 1)
        
        consumable.skipByte()
        #expect(consumable.index == 2)
        
        let byte2 = consumable.readNextByte()
        #expect(byte2 == 2)
    }
    
    @Test
    func skipByteEmptyArray() throws {
        let consumable = ConsumableData(bytes: [])
        try #require(consumable.index == 0)
        
        consumable.skipByte()
        #expect(consumable.index == 0)
    }
    
    @Test
    func skipBytes() throws {
        let bytes = (0..<4).map { i in UInt8(i) }
        let consumable = ConsumableData(bytes: bytes)
        try #require(consumable.index == 0)
        
        consumable.skip(bytes: 2)
        #expect(consumable.index == 2)
        
        let byte1 = consumable.readNextByte()
        #expect(byte1 == 2)
        
        consumable.skip(bytes: 2)
        #expect(consumable.index == 4)
        
        let byte2 = consumable.readNextByte()
        #expect(byte2 == nil)
    }
    
    @Test
    func skipBytesClampsOverflowingNumberOfBytes() throws {
        let bytes = (0..<2).map { i in UInt8(i) }
        let consumable = ConsumableData(bytes: bytes)
        try #require(consumable.index == 0)
        
        consumable.skip(bytes: 4)
        #expect(consumable.index == 2)
        
        let byte1 = consumable.readNextByte()
        #expect(byte1 == nil)
    }
    
    @Test
    func skipBytesEmptyArray() throws {
        let consumable = ConsumableData(bytes: [])
        try #require(consumable.index == 0)
        
        consumable.skip(bytes: 4)
        #expect(consumable.index == 0)
        
        let byte1 = consumable.readNextByte()
        #expect(byte1 == nil)
    }
}
