//
//  ImagePaletteEngine.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 29/09/2025.
//

import CoreGraphics

@available(macOS 13.0, *)
public final class ImagePaletteEngine {
    private let paletteComputer: any ImagePaletteComputer
    
    public init(cgImage: CGImage, method: ImagePaletteComputationMethod) throws(ImagePaletteComputationError) {
        self.paletteComputer = try method.computer(cgImage: cgImage)
    }
    
    public func dominantColors(amount: Int) -> [SIMD3<Float>] {
        paletteComputer.dominantColors(amount: amount)
    }
}
