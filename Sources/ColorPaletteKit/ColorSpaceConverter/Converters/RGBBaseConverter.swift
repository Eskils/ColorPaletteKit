//
//  RGBBaseConverter.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

import CoreGraphics

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

struct RGBBaseConverter: BaseColorConverter {
    let target: ColorSpaceKind
    let requiredNumberOfValues = 3
    
    func rgb(from values: [Float]) throws(ColorConverterError) -> [Float] {
        values
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
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        
        #if canImport(UIKit)
        let color = UIColor(cgColor: cgColor(of: values))
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        #else
        let color = NSColor(
            red: CGFloat(values[0]),
            green: CGFloat(values[1]),
            blue: CGFloat(values[2]),
            alpha: 1
        )
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        #endif
        
        return [Float(hue), Float(saturation), Float(brightness)]
    }
    
    func gray(from values: [Float]) throws(ColorConverterError) -> [Float] {
        try convert(values: values, to: CGColorSpaceCreateDeviceGray())
    }
}

extension RGBBaseConverter: CGColorConvertible {
    func cgColor(of values: [Float]) -> CGColor {
        CGColor(
            red: CGFloat(values[0]),
            green: CGFloat(values[1]),
            blue: CGFloat(values[2]),
            alpha: 1
        )
    }
}
