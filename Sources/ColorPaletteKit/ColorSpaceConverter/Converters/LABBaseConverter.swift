//
//  LABBaseConverter.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

import CoreGraphics

struct LABBaseConverter: BaseColorConverter {
    let target: ColorSpaceKind
    let requiredNumberOfValues = 3
    
    func rgb(from values: [Float]) throws(ColorConverterError) -> [Float] {
        try convert(values: values, to: CGColorSpaceCreateDeviceRGB())
    }
    
    func cmyk(from values: [Float]) throws(ColorConverterError) -> [Float] {
        try convert(values: values, to: CGColorSpaceCreateDeviceCMYK())
    }
    
    func lab(from values: [Float]) throws(ColorConverterError) -> [Float] {
        values
    }
    
    func hsb(from values: [Float]) throws(ColorConverterError) -> [Float] {
        let rgbValues = try rgb(from: values)
        return try RGBBaseConverter(target: .hsb).hsb(from: rgbValues)
    }
    
    func gray(from values: [Float]) throws(ColorConverterError) -> [Float] {
        try convert(values: values, to: CGColorSpaceCreateDeviceGray())
    }
}

extension LABBaseConverter: CGColorConvertible {
    func cgColor(of values: [Float]) throws(ColorConverterError) -> CGColor {
        let colorSpaceName = CGColorSpace.genericLab
        guard let colorSpace = CGColorSpace(name: colorSpaceName) else {
            throw .invalidColorSpace(name: colorSpaceName as String)
        }
        
        
        let floatComponents = values.count >= (requiredNumberOfValues + 1) ? values : values + [1]
        let cgComponents = floatComponents.map { CGFloat($0) }
        
        let color = cgComponents.withUnsafeBufferPointer { componentsBuffer in
            CGColor(colorSpace: colorSpace, components: componentsBuffer.baseAddress!)
        }
        
        guard let color else {
            throw .cannotRepresentColorInColorSpace(name: colorSpaceName as String)
        }
        return color
    }
}
