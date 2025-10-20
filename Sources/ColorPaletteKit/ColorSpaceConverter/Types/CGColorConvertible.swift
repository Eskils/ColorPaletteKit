//
//  CGColorConvertable.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

import CoreGraphics

protocol CGColorConvertible {
    func cgColor(of values: [Float]) throws(ColorConverterError) -> CGColor
}

extension CGColorConvertible {
    func convert(values: [Float], to colorSpace: CGColorSpace) throws(ColorConverterError) -> [Float] {
        let cgColor = try cgColor(of: values)
        guard
            let converted = cgColor.converted(to: colorSpace, intent: .defaultIntent, options: nil),
            let components = components(of: converted)
        else {
            throw .invalidConversion
        }
        
        return components
    }
    
    func components(of cgColor: CGColor) -> [Float]? {
        guard let components = cgColor.components else {
            return nil
        }
        
        return components.map { Float($0) }
    }
}
