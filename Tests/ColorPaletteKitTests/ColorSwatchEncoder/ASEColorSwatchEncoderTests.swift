//
//  ASEColorSwatchEncoderTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 13/10/2025.
//

import Foundation
import Testing
import ColorPaletteKit

struct ASEColorSwatchEncoderTests {
    private let testsDirectory = URL(fileURLWithPath: #filePath + "/../../../").standardizedFileURL
        
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory.path)/\(directory)/\(name)"
    }
    
    @Test
    func encodesHeaderOfEmptySwatch() throws {
        let expectedBytes: [UInt8] = [
            65, 83, 69, 70,
            0, 1, 0, 0,
            0, 0, 0, 0,
        ]
        let encoder = ASEColorSwatchEncoder()
        let data = try encoder.encode([])
        let bytes = [UInt8](data)
        #expect(bytes == expectedBytes)
    }
    
    @Test
    func encodesSingleColor() throws {
        let expectedBytes: [UInt8] = [
            65, 83, 69, 70,
            0, 1, 0, 0,
            0, 0, 0, 1,
            0, 1,
            0, 0, 0, 22,
            0, 1, 0, 0,
            82, 71, 66, 32,
            63, 0, 0, 0,
            63, 0, 0, 0,
            63, 0, 0, 0,
            0, 0
        ]
        let encoder = ASEColorSwatchEncoder()
        let data = try encoder.encode(
            [
                .colorEntry(
                    ASEColorSwatchBlock.ColorEntry(
                        name: "",
                        colorModel: .rgb,
                        colorType: .global,
                        components: [0.5, 0.5, 0.5]
                    )
                )
            ]
        )
        let bytes = [UInt8](data)
        #expect(bytes == expectedBytes)
    }
    
    @Test
    func encodesGroup() throws {
        let path = filePath(name: "group-palette.ase", directory: "TestAssets/Swatches/ASE")
        let expectedData = try Data(contentsOf: URL(filePath: path))
        let encoder = ASEColorSwatchEncoder()
        let data = try encoder.encode(
            [
                .group(
                    ASEColorSwatchBlock.Group(
                        name: "Adobe Swatch Exchange file",
                        components: [
                            .colorEntry(
                                ASEColorSwatchBlock.ColorEntry(
                                    name: "",
                                    colorModel: .rgb,
                                    colorType: .normal,
                                    components: [0.0196078, 0.580392, 0.509804]
                                )
                            ),
                            .colorEntry(
                                ASEColorSwatchBlock.ColorEntry(
                                    name: "",
                                    colorModel: .rgb,
                                    colorType: .normal,
                                    components: [0.0, 0.619608, 0.25098]
                                )
                            ),
                            .colorEntry(
                                ASEColorSwatchBlock.ColorEntry(
                                    name: "",
                                    colorModel: .rgb,
                                    colorType: .normal,
                                    components: [0.0470588, 0.529412, 0.0]
                                )
                            ),
                            .colorEntry(
                                ASEColorSwatchBlock.ColorEntry(
                                    name: "",
                                    colorModel: .rgb,
                                    colorType: .normal,
                                    components: [0.427451, 0.619608, 0.0313726]
                                )
                            ),
                            .colorEntry(
                                ASEColorSwatchBlock.ColorEntry(
                                    name: "",
                                    colorModel: .rgb,
                                    colorType: .normal,
                                    components: [0.580392, 0.537255, 0.0]
                                )
                            )
                        ]
                    )
                )
            ]
        )
        let bytes = [UInt8](data)
        #expect(bytes == [UInt8](expectedData))
    }
}
