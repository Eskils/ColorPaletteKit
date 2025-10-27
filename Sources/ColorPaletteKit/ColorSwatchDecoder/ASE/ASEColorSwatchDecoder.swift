//
//  ASEColorSwatchDecoder.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 05/10/2025.
//

import Foundation

/// Object to decode color schemes in the Adobe Swatch Exchange (ASE) format.
public struct ASEColorSwatchDecoder: ColorSwatchDecoder {
    private let expectedFormat = "ASEF"
    private let supportedVersions = [
        1: Set([0])
    ]
    
    public init() {
    }
    
    /// Decode swatch from `data` to a list of RGB colors.
    /// - Parameter data: The data to decode
    /// - Returns: A list of RGB color values
    public func decodeColors(from data: Data) throws(ColorSwatchDecoderError) -> [SIMD3<Float>] {
        let (colors, _) = try decodeColorsAndGroupName(from: data)
        return colors
    }
    
    
    /// Decode swatch from `data` to a list of RGB colors and a name if it exists.
    /// - Parameter data: The data to decode
    /// - Returns: A list of RGB color values and group name
    public func decodeColorsAndGroupName(from data: Data) throws(ColorSwatchDecoderError) -> (colors: [SIMD3<Float>], name: String?) {
        let blocks = try decode(from: data)
        let name: String? = if let firstBlock = blocks.first, case let .group(group) = firstBlock {
            group.name
        } else {
            nil
        }
        let colorEntries = blocks.flatMap { $0.colorEntries }
        do {
            let colors = try colorEntries.map { entry throws(ColorConverterError) in
                let converter = ColorSpaceConverter(from: entry.colorModel.colorSpaceKind, to: .rgb)
                let convertedColor = try converter.convert(color: entry.components)
                return SIMD3(convertedColor)
            }
            return (colors, name)
        } catch {
            throw .cannotConvertColor(underlying: error)
        }
    }
    
    /// Decode swatch from `data`.
    /// - Parameter data: The data to decode  in ASE format
    /// - Returns: A list of color swatch blocks
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
        let groupName = data.readUTF16(of: Int(nameCount), mode: .consume).trimmingCharacters(in: .controlCharacters)
        
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
        let colorName = data.readUTF16(of: Int(nameCount), mode: .consume).trimmingCharacters(in: .controlCharacters)
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
