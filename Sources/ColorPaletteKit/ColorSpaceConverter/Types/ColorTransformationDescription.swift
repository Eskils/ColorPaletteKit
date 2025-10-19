//
//  ColorTransformationDescription.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

struct ColorTransformationDescription {
    let base: ColorSpaceKind
    let target: ColorSpaceKind
    
    func converter() -> ColorConverterComputer {
        switch base {
        case .rgb:
            RGBBaseConverter(target: target)
        case .cmyk:
            CMYKBaseConverter(target: target)
        case .lab:
            LABBaseConverter(target: target)
        case .hsb:
            HSBBaseConverter(target: target)
        case .gray:
            GrayBaseConverter(target: target)
        }
    }
}
