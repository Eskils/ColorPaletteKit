//
//  ColorSwatchDecoderError.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 05/10/2025.
//

/// Possible errors that can occur when decoding a swatch
public enum ColorSwatchDecoderError: Error, Equatable {
    /// The data is in the incorrect format.
    case invalidFormat(received: String, expected: String)
    /// The data has been encoded in a version of the format which is not supported.
    case unsupportedVersion(major: Int, minor: Int)
    /// An invalid block type was read.
    case invalidBlockType(typeIdentifier: UInt16)
    /// An invalid color model was read
    case invalidColorModel(identifier: String)
    /// An invalid color type was read
    case invalidColorType(identifier: UInt16)
    /// A read color could not be converted to the required color space.
    case cannotConvertColor(underlying: ColorConverterError)
}
