//
//  ImagePaletteComputationError.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 04/10/2025.
//

/// Possible errors that could occur when computing the dominant colors in an image.
public enum ImagePaletteComputationError: Error {
    /// The image could not be converted to the appropriate format.
    case cannotMakeImageFormat
    /// The pixel data of the image could not be read.
    case cannotExtractImageData
}
