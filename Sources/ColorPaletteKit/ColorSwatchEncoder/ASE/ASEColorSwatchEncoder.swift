//
//  ASEColorSwatchEncoder.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 12/10/2025.
//

import Foundation

/// Object to encode a color swatch in the Adobe Swatch Exchange (ASE) format.
public struct ASEColorSwatchEncoder: ColorSwatchEncoder {
    public init() {
    }
    
    /// Encode `swatch` in ASE format.
    /// - Parameter swatch: A list of color blocks.
    /// - Returns: Encoded data
    public func encode(_ swatch: [ASEColorSwatchBlock]) throws(ColorSwatchEncoderError) -> Data {
        let writable = WritableData()
        
        let numberOfBlocks = swatch.reduce(0) { partialResult, block in
            partialResult + block.numberOfBlocks
        }
        let header = ASEColorSwatchHeader(format: "ASEF", version: (1, 0), numberOfBlocks: UInt32(numberOfBlocks))
        write(header: header, to: writable)
        
        for block in swatch {
            write(block: block, to: writable)
        }
        
        return Data(writable.bytes)
    }
    
    private func write(header: ASEColorSwatchHeader, to data: WritableData) {
        data.writeUTF8(string: header.format)
        data.write(int16: header.version.major)
        data.write(int16: header.version.minor)
        data.write(int32: header.numberOfBlocks)
    }
    
    private func write(block: ASEColorSwatchBlock, to data: WritableData) {
        switch block {
        case .group(let group):
            write(group: group, to: data)
        case .colorEntry(let colorEntry):
            write(colorEntry: colorEntry, to: data)
        }
    }
    
    private func write(group: ASEColorSwatchBlock.Group, to data: WritableData) {
        let blockData = WritableData()
        blockData.writeUTF16(string: group.name, representation: [.lengthPrefixed, .nullTerminated])
        
        data.write(int16: ASEColorSwatchBlock.ExtensiveKind.groupStart.identifier)
        data.write(int32: UInt32(blockData.count))
        data.append(blockData)
        
        for component in group.components {
            write(block: component, to: data)
        }
        
        data.write(int16: ASEColorSwatchBlock.ExtensiveKind.groupEnd.identifier)
        data.write(int32: 0)
    }
    
    private func write(colorEntry: ASEColorSwatchBlock.ColorEntry, to data: WritableData) {
        let blockData = WritableData()
        blockData.writeUTF16(string: colorEntry.name, representation: [.lengthPrefixed, .nullTerminated])
        blockData.writeUTF8(string: colorEntry.colorModel.identifier)
        write(colorValues: colorEntry.components, for: colorEntry.colorModel, to: blockData)
        blockData.write(int16: colorEntry.colorType.identifier)
        
        data.write(int16: ASEColorSwatchBlock.ExtensiveKind.colorEntry.identifier)
        data.write(int32: UInt32(blockData.count))
        data.append(blockData)
    }
    
    private func write(colorValues: [Float], for model: ASEColorSwatchBlock.ColorModel, to data: WritableData) {
        (0..<model.numberOfComponents).forEach { i in
            let value = colorValues.indices.contains(i) ? colorValues[i] : 0
            let valueAsInt32 = withUnsafePointer(to: value) { pointer in
                UnsafeRawPointer(pointer)
                    .assumingMemoryBound(to: UInt32.self)
                    .pointee
            }
            data.write(int32: valueAsInt32)
        }
    }
}
