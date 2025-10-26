//
//  ColorSwatchDecoder.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 05/10/2025.
//

import Foundation

/// Implement this protocol to define a new color swatch decoder
public protocol ColorSwatchDecoder {
    associatedtype ColorSwatchResult
    /// Decode a swatch from `data`
    /// - Parameter data: The data to decode in the implemented format
    /// - Returns: The decoded swatch
    func decode(from data: Data) throws(ColorSwatchDecoderError) -> ColorSwatchResult
}
