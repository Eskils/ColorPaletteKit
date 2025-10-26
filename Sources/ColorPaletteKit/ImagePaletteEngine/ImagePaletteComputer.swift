//
//  ImagePaletteComputer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 29/09/2025.
//

import CoreGraphics

/// Implement this protocol to define a new ImagePaletteComputer.
///
/// A new image palette computer should add a new case to ``ImagePaletteComputationMethod``
/// to allow using this computer in the ``ImagePaletteEngine``.
public protocol ImagePaletteComputer<Parameters> {
    associatedtype Parameters
    
    /// Construct a new ImagePaletteComputer to find the dominant colors in `cgImage` according to `parameters`.
    /// - Parameters:
    ///   - cgImage: The image from which to extract colors
    ///   - parameters: The settings for the computation method
    init(cgImage: CGImage, parameters: Parameters) throws(ImagePaletteComputationError)
    
    /// Extract `amount` dominant colors.
    /// - Parameter amount: Number of colors to extract
    /// - Returns: A list of the dominant colors in the image.
    func dominantColors(amount: Int) -> [SIMD3<Float>]
}
