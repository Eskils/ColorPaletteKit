//
//  ColorConverterComputer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

/// Implement this protocol to define a new color converter.
public protocol ColorConverterComputer {
    /// Convert `colorValues` to the target color space.
    /// - Parameter colorValues: List of color values in the base color space
    /// - Returns: List of color values in the target color space
    func convert(colorValues: [Float]) throws(ColorConverterError) -> [Float]
}
