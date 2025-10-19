//
//  BaseColorConverter.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

protocol BaseColorConverter: ColorConverterComputer {
    var target: ColorSpaceKind { get }
    var requiredNumberOfValues: Int { get }
    
    func rgb(from values: [Float]) throws(ColorConverterError) -> [Float]
    func cmyk(from values: [Float]) throws(ColorConverterError) -> [Float]
    func lab(from values: [Float]) throws(ColorConverterError) -> [Float]
    func hsb(from values: [Float]) throws(ColorConverterError) -> [Float]
    func gray(from values: [Float]) throws(ColorConverterError) -> [Float]
}

extension BaseColorConverter {
    func convert(colorValues: [Float]) throws(ColorConverterError) -> [Float] {
        let numberOfValues = colorValues.count
        guard numberOfValues >= requiredNumberOfValues else {
            throw .tooFewColorValues(received: numberOfValues, expected: requiredNumberOfValues)
        }
        
        return switch target {
        case .rgb:
            try rgb(from: colorValues)
        case .cmyk:
            try cmyk(from: colorValues)
        case .lab:
            try lab(from: colorValues)
        case .hsb:
            try hsb(from: colorValues)
        case .gray:
            try gray(from: colorValues)
        }
    }
}
