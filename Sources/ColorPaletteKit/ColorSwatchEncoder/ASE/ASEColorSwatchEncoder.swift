//
//  ASEColorSwatchEncoder.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 12/10/2025.
//

import Foundation

public struct ASEColorSwatchEncoder: ColorSwatchEncoder {
    public init() {
    }
    
    public func encode(_ swatch: [ASEColorSwatchBlock]) throws(ColorSwatchEncoderError) -> Data {
        let writable = WritableData()
        
        let numberOfBlocks = swatch.reduce(0) { partialResult, block in
            partialResult + block.numberOfBlocks
        }
        let header = ASEColorSwatchHeader(format: "ASEF", version: (1, 0), numberOfBlocks: UInt32(numberOfBlocks))
        write(header: header, to: writable)
        
        return Data(writable.bytes)
    }
    
    private func write(header: ASEColorSwatchHeader, to data: WritableData) {
        data.writeUTF8(string: header.format)
        data.write(int16: header.version.major)
        data.write(int16: header.version.minor)
        data.write(int32: header.numberOfBlocks)
    }
}
