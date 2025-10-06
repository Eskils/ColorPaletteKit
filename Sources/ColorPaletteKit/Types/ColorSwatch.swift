//
//  ColorSwatch.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 05/10/2025.
//


public struct ColorSwatch {
    public let colors: [SIMD3<Float>]
    
    public init(colors: [SIMD3<Float>]) {
        self.colors = colors
    }
}
