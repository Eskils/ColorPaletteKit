//
//  ASEColorSwatchDecoder.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 05/10/2025.
//

import Foundation

public struct ASEColorSwatchDecoder: ColorSwatchDecoder {
    private let expectedFormat = "ASEF"
    private let supportedVersions = [
        1: Set([0])
    ]
    
    public init() {
    }
    
    public func decode(from data: Data) throws(ColorSwatchDecoderError) -> [ASEColorSwatchBlock] {
        let consumable = ConsumableData(data: data)
        let header = readHeader(data: consumable)
        
        guard header.format == expectedFormat else {
            throw .invalidFormat(received: header.format, expected: expectedFormat)
        }
        
        let majorVersion = Int(header.version.major)
        let minorVersion = Int(header.version.minor)
        guard (supportedVersions[majorVersion] ?? Set()).contains(minorVersion) else {
            throw .unsupportedVersion(major: majorVersion, minor: minorVersion)
        }
        
        var colorBlocks = [ASEColorSwatchBlock]()
        
        while !consumable.isAtEnd {
            guard let block = try readBlock(data: consumable) else {
                continue
            }
            colorBlocks.append(block)
        }
                
        return colorBlocks
    }
    
    private func readHeader(data: ConsumableData) -> ASEColorSwatchHeader {
        let format = data.readASCII(of: 4, mode: .consume)
        let majorVersion = data.readInt16(mode: .consume)
        let minorVersion = data.readInt16(mode: .consume)
        let numberOfBlocks = data.readInt32(mode: .consume)
        
        return ASEColorSwatchHeader(
            format: format,
            version: (majorVersion, minorVersion),
            numberOfBlocks: numberOfBlocks
        )
    }
    
    private func readBlock(data: ConsumableData) throws(ColorSwatchDecoderError) -> ASEColorSwatchBlock? {
        let typeIdentifier = data.readInt16(mode: .consume)
        
        guard let type = ASEColorSwatchBlock.ExtensiveKind(identifier: typeIdentifier) else {
            throw .invalidBlockType(typeIdentifier: typeIdentifier)
        }
        
        return switch type {
        case .groupStart:
            try readGroup(data: data)
        case .groupEnd: {
            data.skip(bytes: 4)
            return nil
        }()
        case .colorEntry:
            try readColorEntry(data: data)
        }
    }
    
    private func readGroup(data: ConsumableData) throws(ColorSwatchDecoderError) -> ASEColorSwatchBlock {
        // Skip block count
        data.skip(bytes: 4)
        let nameCount = data.readInt16(mode: .consume)
        let groupName = data.readUTF16(of: Int(nameCount), mode: .consume)
        
        var components = [ASEColorSwatchBlock]()
        
        while let nextBlock = try readBlock(data: data) {
            components.append(nextBlock)
        }
        
        return .group(
            ASEColorSwatchBlock.Group(
                name: groupName,
                components: components
            )
        )
    }
    
    private func readColorEntry(data: ConsumableData) throws(ColorSwatchDecoderError) -> ASEColorSwatchBlock {
        // Skip block count
        data.skip(bytes: 4)
        let nameCount = data.readInt16(mode: .consume)
        let colorName = data.readUTF16(of: Int(nameCount), mode: .consume)
        let colorModelIdentifier = data.readASCII(of: 4, mode: .consume)
        
        guard let colorModel = ASEColorSwatchBlock.ColorModel(identifier: colorModelIdentifier) else {
            throw .invalidColorModel(identifier: colorModelIdentifier)
        }
                
        let components = try readColorValues(of: colorModel, in: data)
        
        let colorTypeIdentifier = data.readInt16(mode: .consume)
        guard let colorType = ASEColorSwatchBlock.ColorType(identifier: colorTypeIdentifier) else {
            throw .invalidColorType(identifier: colorTypeIdentifier)
        }
        
        return .colorEntry(
            ASEColorSwatchBlock.ColorEntry(
                name: colorName,
                colorModel: colorModel,
                colorType: colorType,
                components: components
            )
        )
    }
    
    private func readColorValues(of model: ASEColorSwatchBlock.ColorModel, in data: ConsumableData) throws(ColorSwatchDecoderError) -> [Float] {
        (0..<model.numberOfComponents).map { _ in
            let bytes = data.readInt32(mode: .consume)
            return withUnsafePointer(to: bytes) { pointer in
                UnsafeRawPointer(pointer)
                    .assumingMemoryBound(to: Float.self)
                    .pointee
            }
        }
    }
}
