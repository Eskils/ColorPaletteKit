//
//  PaletteImageRenderer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

import CoreGraphics

public protocol PaletteImageRenderer {
    func render(colors: [SIMD3<Float>], size: CGSize) throws(PaletteImageRendererError) -> CGImage
}

public enum PaletteImageRendererError: Error {
    case renderFailure(underlying: Error)
}
