//
//  ColorConverterError.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 19/10/2025.
//

/// Possible errors that can occur when converting a color
public enum ColorConverterError: Error {
    /// The color has too few values than required by the base format.
    case tooFewColorValues(received: Int, expected: Int)
    /// This base to target conversion is not supported.
    case invalidConversion
    /// Some color space could not be created.
    case invalidColorSpace(name: String)
    /// Some color could not be represented in a color space.
    case cannotRepresentColorInColorSpace(name: String)
}

extension ColorConverterError: Equatable {
}
