//
//  PaletteImageRenderer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

import CoreGraphics

/// Implement this protocol to define a new PaletteImageRenderer.
/// You may then add a new case to ``PaletteImageRendererKind``
/// to allow using this renderer in the ``PaletteImageEngine``.
public protocol PaletteImageRenderer {
    /// Render `colors` to an image of the requested `size`.
    /// - Parameters:
    ///   - colors: A list of colors in the RGB color space
    ///   - size: The size of the image
    /// - Returns: An image with the rendered colors.
    func render(colors: [SIMD3<Float>], size: CGSize) throws(PaletteImageRendererError) -> CGImage
}

/// Possible errors that could occur when rendering a palette image
public enum PaletteImageRendererError: Error {
    /// The image could not be rendered due to the underlying error.
    case renderFailure(underlying: Error)
}
