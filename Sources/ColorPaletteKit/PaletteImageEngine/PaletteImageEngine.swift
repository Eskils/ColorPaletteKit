//
//  PaletteImageEngine.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

import CoreGraphics

public final class PaletteImageEngine {
    private let renderer: PaletteImageRenderer
    
    public init(kind: PaletteImageRendererKind) {
        self.renderer = kind.renderer()
    }
    
    public func render(colors: [SIMD3<Float>], size: CGSize) throws(PaletteImageRendererError) -> CGImage {
        try renderer.render(colors: colors, size: size)
    }
}
