//
//  ImagePaletteEngine.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 29/09/2025.
//

import CoreGraphics

/// Object to compute the dominant colors in an image.
@available(macOS 13.0, iOS 16.0, *)
public final class ImagePaletteEngine {
    private let paletteComputer: any ImagePaletteComputer
    
    /// Construct a new ImagePaletteComputer to find the dominant colors in `cgImage` using `method`.
    /// - Parameters:
    ///   - cgImage: The image from which to extract colors
    ///   - method: The computation method
    public init(cgImage: CGImage, method: ImagePaletteComputationMethod) throws(ImagePaletteComputationError) {
        self.paletteComputer = try method.computer(cgImage: cgImage)
    }
    
    /// Extract `amount` dominant colors.
    /// - Parameter amount: Number of colors to extract
    /// - Returns: A list of the dominant colors in the image.
    public func dominantColors(amount: Int) -> [SIMD3<Float>] {
        paletteComputer.dominantColors(amount: amount)
    }
}
