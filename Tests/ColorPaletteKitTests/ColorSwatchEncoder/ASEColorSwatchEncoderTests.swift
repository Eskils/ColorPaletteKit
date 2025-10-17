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
}
