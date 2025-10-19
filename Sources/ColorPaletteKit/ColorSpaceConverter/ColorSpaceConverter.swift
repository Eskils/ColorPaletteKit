//
//  ColorSpaceConverter.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

public struct ColorSpaceConverter {
    private let converter: any ColorConverterComputer
    
    public init(from base: ColorSpaceKind, to target: ColorSpaceKind) {
        let transformation = ColorTransformationDescription(
            base: base,
            target: target
        )
        self.converter = transformation.converter()
    }
    
    public func convert(color: [Float]) throws(ColorConverterError) -> [Float] {
        try converter.convert(colorValues: color)
    }
}
