//
//  ColorSwatchDecoderError.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 05/10/2025.
//


public enum ColorSwatchDecoderError: Error, Equatable {
    case invalidFormat(received: String, expected: String)
    case unsupportedVersion(major: Int, minor: Int)
    case invalidBlockType(typeIdentifier: UInt16)
    case invalidColorModel(identifier: String)
    case invalidColorType(identifier: UInt16)
}
