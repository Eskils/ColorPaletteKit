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
}
