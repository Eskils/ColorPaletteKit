//
//  ColorSwatchEncoder.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 12/10/2025.
//

import Foundation

public protocol ColorSwatchEncoder {
    associatedtype ColorSwatchInput
    func encode(_ swatch: ColorSwatchInput) throws(ColorSwatchEncoderError) -> Data
}
