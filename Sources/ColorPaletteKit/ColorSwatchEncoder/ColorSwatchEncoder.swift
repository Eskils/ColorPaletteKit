//
//  ColorSwatchEncoder.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 12/10/2025.
//

import Foundation

/// Implement this protocol to define a new color swatch encoder.
public protocol ColorSwatchEncoder {
    associatedtype ColorSwatchInput
    /// Encode `swatch` in the implemented format.
    /// - Parameter swatch: The swatch to encode
    /// - Returns: Encoded data
    func encode(_ swatch: ColorSwatchInput) throws(ColorSwatchEncoderError) -> Data
}
