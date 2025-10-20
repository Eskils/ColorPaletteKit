//
//  GrayBaseConverter.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

import CoreGraphics

struct GrayBaseConverter: BaseColorConverter {
    let target: ColorSpaceKind
    let requiredNumberOfValues = 1
    
    func rgb(from values: [Float]) throws(ColorConverterError) -> [Float] {
        [Float](repeating: values[0], count: 3)
    }
    
    func cmyk(from values: [Float]) throws(ColorConverterError) -> [Float] {
        try convert(values: values, to: CGColorSpaceCreateDeviceCMYK())
    }
    
    func lab(from values: [Float]) throws(ColorConverterError) -> [Float] {
        let colorSpaceName = CGColorSpace.genericLab
        guard let colorSpace = CGColorSpace(name: colorSpaceName) else {
            throw .invalidColorSpace(name: colorSpaceName as String)
        }
        return try convert(values: values, to: colorSpace)
    }
    
    func hsb(from values: [Float]) throws(ColorConverterError) -> [Float] {
        let rgbValues = try rgb(from: values)
        return try RGBBaseConverter(target: .hsb).hsb(from: rgbValues)
    }
    
    func gray(from values: [Float]) throws(ColorConverterError) -> [Float] {
        values
    }
}

extension GrayBaseConverter: CGColorConvertible {
    func cgColor(of values: [Float]) throws(ColorConverterError) -> CGColor {
        CGColor(
            gray: CGFloat(values[0]),
            alpha: 1
        )
    }
}
