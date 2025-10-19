//
//  ColorConverterComputer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

public protocol ColorConverterComputer {
    func convert(colorValues: [Float]) throws(ColorConverterError) -> [Float]
}
