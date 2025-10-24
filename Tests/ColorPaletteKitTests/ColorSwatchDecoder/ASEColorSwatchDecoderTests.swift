//
//  ASEColorSwatchDecoderTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 08/10/2025.
//

import Foundation
import Testing
import ColorPaletteKit

struct ASEColorSwatchDecoderTests {
    private let testsDirectory = URL(fileURLWithPath: #filePath + "/../../../").standardizedFileURL
        
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory.path)/\(directory)/\(name)"
    }
        
    @Test
    func decodePaletteWithoutNames() throws {
        let expectedPalette: [ASEColorSwatchBlock] = [
            .colorEntry(
                ASEColorSwatchBlock.ColorEntry(
                    name: "",
                    colorModel: .rgb,
                    colorType: .global,
                    components: [0.8901961, 0.45882353, 1.0]
                )
            ),
            .colorEntry(
                ASEColorSwatchBlock.ColorEntry(
                    name: "",
                    colorModel: .rgb,
                    colorType: .global,
                    components: [0.5019608, 0.49411765, 1.0]
                )
            ),
            .colorEntry(
                ASEColorSwatchBlock.ColorEntry(
                    name: "",
                    colorModel: .rgb,
                    colorType: .global,
                    components: [1.0, 0.44313726, 0.1882353]
                )
            ),
            .colorEntry(
                ASEColorSwatchBlock.ColorEntry(
                    name: "",
                    colorModel: .rgb,
                    colorType: .global,
                    components: [0.3372549, 1.0, 0.6]
                )
            )
        ]
        
        let path = filePath(name: "simple-palette.ase", directory: "TestAssets/Swatches/ASE")
        let data = try Data(contentsOf: URL(filePath: path))
        let decoder = ASEColorSwatchDecoder()
        let blocks = try decoder.decode(from: data)
        
        #expect(blocks == expectedPalette)
    }
    
    @Test
    func decodePaletteWithGroup() throws {
        let expectedPalette: [ASEColorSwatchBlock] = [
            .group(
                ASEColorSwatchBlock.Group(
                    name: "Adobe Swatch Exchange file\0",
                    components: [
                        .colorEntry(
                            ASEColorSwatchBlock.ColorEntry(
                                name: "\0",
                                colorModel: .rgb,
                                colorType: .normal,
                                components: [0.0196078, 0.580392, 0.509804]
                            )
                        ),
                        .colorEntry(
                            ASEColorSwatchBlock.ColorEntry(
                                name: "\0",
                                colorModel: .rgb,
                                colorType: .normal,
                                components: [0.0, 0.619608, 0.25098]
                            )
                        ),
                        .colorEntry(
                            ASEColorSwatchBlock.ColorEntry(
                                name: "\0",
                                colorModel: .rgb,
                                colorType: .normal,
                                components: [0.0470588, 0.529412, 0.0]
                            )
                        ),
                        .colorEntry(
                            ASEColorSwatchBlock.ColorEntry(
                                name: "\0",
                                colorModel: .rgb,
                                colorType: .normal,
                                components: [0.427451, 0.619608, 0.0313726]
                            )
                        ),
                        .colorEntry(
                            ASEColorSwatchBlock.ColorEntry(
                                name: "\0",
                                colorModel: .rgb,
                                colorType: .normal,
                                components: [0.580392, 0.537255, 0.0]
                            )
                        )
                    ]
                )
            )
        ]
        
        let path = filePath(name: "group-palette.ase", directory: "TestAssets/Swatches/ASE")
        let data = try Data(contentsOf: URL(filePath: path))
        let decoder = ASEColorSwatchDecoder()
        let blocks = try decoder.decode(from: data)
        
        #expect(blocks == expectedPalette)
    }
    
    @Test
    func decodePaletteIntoColors() throws {
        let expectedColors: [SIMD3<Float>] = [
            SIMD3(0.8901961, 0.45882353, 1.0),
            SIMD3(0.5019608, 0.49411765, 1.0),
            SIMD3(1.0, 0.44313726, 0.1882353),
            SIMD3(0.3372549, 1.0, 0.6)
        ]
        
        let path = filePath(name: "simple-palette.ase", directory: "TestAssets/Swatches/ASE")
        let data = try Data(contentsOf: URL(filePath: path))
        let decoder = ASEColorSwatchDecoder()
        let blocks = try decoder.decodeColors(from: data)
        
        #expect(blocks == expectedColors)
    }
    
    @Test
    func decodePaletteWithGroupIntoColors() throws {
        let expectedColors: [SIMD3<Float>] = [
            SIMD3(0.0196078, 0.580392, 0.509804),
            SIMD3(0.0, 0.619608, 0.25098),
            SIMD3(0.0470588, 0.529412, 0.0),
            SIMD3(0.427451, 0.619608, 0.0313726),
            SIMD3(0.580392, 0.537255, 0.0)
        ]
        
        let path = filePath(name: "group-palette.ase", directory: "TestAssets/Swatches/ASE")
        let data = try Data(contentsOf: URL(filePath: path))
        let decoder = ASEColorSwatchDecoder()
        let blocks = try decoder.decodeColors(from: data)
        
        #expect(blocks == expectedColors)
    }
    
    @Test
    func decodePaletteWithInvalidFormatInHeader() throws {
        let bytes: [UInt8] = [65, 66, 67, 68]
        let data = Data(bytes)
        let decoder = ASEColorSwatchDecoder()
        #expect(throws: ColorSwatchDecoderError.invalidFormat(received: "ABCD", expected: "ASEF")) {
            try decoder.decode(from: data)
        }
    }
    
    @Test
    func decodePaletteWithUnsupportedVersion() throws {
        let bytes: [UInt8] = [65, 83, 69, 70, 0, 0, 0, 0]
        let data = Data(bytes)
        let decoder = ASEColorSwatchDecoder()
        #expect(throws: ColorSwatchDecoderError.unsupportedVersion(major: 0, minor: 0)) {
            try decoder.decode(from: data)
        }
    }
    
    @Test
    func decodePaletteWithEmptyBlocks() throws {
        let bytes: [UInt8] = [65, 83, 69, 70, 0, 1, 0, 0]
        let data = Data(bytes)
        let decoder = ASEColorSwatchDecoder()
        #expect(try decoder.decode(from: data).isEmpty)
    }
    
    @Test
    func decodePaletteWithUnsupportedBlockType() throws {
        let bytes: [UInt8] = [
            65, 83, 69, 70,
            0, 1, 0, 0,
            0, 0, 0, 1,
            0, 2
        ]
        let data = Data(bytes)
        let decoder = ASEColorSwatchDecoder()
        #expect(throws: ColorSwatchDecoderError.invalidBlockType(typeIdentifier: 2)) {
            try decoder.decode(from: data)
        }
    }
    
    @Test
    func decodePaletteWithUnsupportedColorModel() throws {
        let bytes: [UInt8] = [
            65, 83, 69, 70,
            0, 1, 0, 0,
            0, 0, 0, 1,
            0, 1, 0, 0, 0, 0, 0, 0,
            65, 66, 67, 32
        ]
        let data = Data(bytes)
        let decoder = ASEColorSwatchDecoder()
        #expect(throws: ColorSwatchDecoderError.invalidColorModel(identifier: "ABC ")) {
            try decoder.decode(from: data)
        }
    }
    
    @Test
    func decodePaletteWithUnsupportedColorType() throws {
        let bytes: [UInt8] = [
            65, 83, 69, 70,
            0, 1, 0, 0,
            0, 0, 0, 1,
            0, 1, 0, 0, 0, 0, 0, 0,
            82, 71, 66, 32,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 3
        ]
        let data = Data(bytes)
        let decoder = ASEColorSwatchDecoder()
        #expect(throws: ColorSwatchDecoderError.invalidColorType(identifier: 3)) {
            try decoder.decode(from: data)
        }
    }
}
