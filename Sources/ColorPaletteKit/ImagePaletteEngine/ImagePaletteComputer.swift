//
//  ImagePaletteComputer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 29/09/2025.
//

import CoreGraphics

public protocol ImagePaletteComputer<Parameters> {
    associatedtype Parameters
    
    init(cgImage: CGImage, parameters: Parameters) throws(ImagePaletteComputationError)
    func dominantColors(amount: Int) -> [SIMD3<Float>]
}
