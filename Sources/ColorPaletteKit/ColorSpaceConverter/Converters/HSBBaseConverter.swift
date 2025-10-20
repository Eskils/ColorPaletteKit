//
//  HSBBaseConverter.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

struct HSBBaseConverter: BaseColorConverter {
    let target: ColorSpaceKind
    let requiredNumberOfValues = 3
    
    init(target: ColorSpaceKind) {
        self.target = target
    }
    
    func rgb(from values: [Float]) throws(ColorConverterError) -> [Float] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        #if canImport(UIKit)
        let color = UIColor(
            hue: CGFloat(values[0]),
            saturation: CGFloat(values[1]),
            brightness: CGFloat(values[2]),
            alpha: 1
        )
        #else
        let color = NSColor(
            hue: CGFloat(values[0]),
            saturation: CGFloat(values[1]),
            brightness: CGFloat(values[2]),
            alpha: 1
        )
        #endif
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return [Float(red), Float(green), Float(blue)]
    }
    
    func cmyk(from values: [Float]) throws(ColorConverterError) -> [Float] {
        let rgbValues = try rgb(from: values)
        return try RGBBaseConverter(target: target).cmyk(from: rgbValues)
    }
    
    func lab(from values: [Float]) throws(ColorConverterError) -> [Float] {
        let rgbValues = try rgb(from: values)
        return try RGBBaseConverter(target: target).lab(from: rgbValues)
    }
    
    func hsb(from values: [Float]) throws(ColorConverterError) -> [Float] {
        values
    }
    
    func gray(from values: [Float]) throws(ColorConverterError) -> [Float] {
        let rgbValues = try rgb(from: values)
        return try RGBBaseConverter(target: target).gray(from: rgbValues)
    }
}
