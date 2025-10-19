//
//  ColorConverterError.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

public enum ColorConverterError: Error {
    case tooFewColorValues(received: Int, expected: Int)
    case invalidConversion
    case invalidColorSpace(name: String)
}
