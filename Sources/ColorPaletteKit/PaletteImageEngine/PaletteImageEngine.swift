//
//  PaletteImageEngine.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

import CoreGraphics

/// Object used to render a palette to an image.
public struct PaletteImageEngine {
    private let renderer: PaletteImageRenderer
    
    public init(kind: PaletteImageRendererKind) {
        self.renderer = kind.renderer()
    }
    
    /// Render `colors` to an image of `size` dimensions.
    /// - Parameters:
    ///   - colors: A list of colors in the RGB color space
    ///   - size: The size of the image
    /// - Returns: An image with the rendered colors.
    public func render(colors: [SIMD3<Float>], size: CGSize) throws(PaletteImageRendererError) -> CGImage {
        try renderer.render(colors: colors, size: size)
    }
}
