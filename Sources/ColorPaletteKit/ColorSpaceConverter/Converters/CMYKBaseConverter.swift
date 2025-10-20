//
//  CMYKBaseConverter.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

import CoreGraphics

struct CMYKBaseConverter: BaseColorConverter {
    let target: ColorSpaceKind
    let requiredNumberOfValues = 4
    
    func rgb(from values: [Float]) throws(ColorConverterError) -> [Float] {
        try convert(values: values, to: CGColorSpaceCreateDeviceRGB())
    }
    
    func cmyk(from values: [Float]) throws(ColorConverterError) -> [Float] {
        values
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
        try convert(values: values, to: CGColorSpaceCreateDeviceGray())
    }
}

extension CMYKBaseConverter: CGColorConvertible {
    func cgColor(of values: [Float]) -> CGColor {
        CGColor(
            genericCMYKCyan: CGFloat(values[0]),
            magenta: CGFloat(values[1]),
            yellow: CGFloat(values[2]),
            black: CGFloat(values[3]),
            alpha: 1
        )
    }
}
