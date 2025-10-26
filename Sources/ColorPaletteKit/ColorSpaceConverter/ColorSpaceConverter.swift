//
//  ColorSpaceConverter.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

/// Object to convert colors from one color space to another.
public struct ColorSpaceConverter {
    private let converter: any ColorConverterComputer
    
    public init(from base: ColorSpaceKind, to target: ColorSpaceKind) {
        let transformation = ColorTransformationDescription(
            base: base,
            target: target
        )
        self.converter = transformation.converter()
    }
    
    /// Convert `color` to the target color space.
    /// - Parameter color: List of color values in the base color space
    /// - Returns: List of color values in the target color space
    public func convert(color: [Float]) throws(ColorConverterError) -> [Float] {
        try converter.convert(colorValues: color)
    }
}
