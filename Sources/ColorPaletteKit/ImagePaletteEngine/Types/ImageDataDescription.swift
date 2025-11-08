//
//  ImageDataDescription.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 28/10/2025.
//

import Accelerate

public struct ImageDataDescription {
    public let data: UnsafeMutablePointer<Float>
    public let width: Int
    public let height: Int
    public let components: Int
    public let isNormalized: Bool
    
    public init(
        data: UnsafeMutablePointer<Float>,
        width: Int,
        height: Int,
        components: Int,
        isNormalized: Bool = true
    ) {
        self.data = data
        self.width = width
        self.height = height
        self.components = components
        self.isNormalized = isNormalized
    }
}

extension ImageDataDescription {
    func imageBuffer() -> vImage_Buffer {
        vImage_Buffer(
            data: UnsafeMutableRawPointer(data),
            height: UInt(height),
            width: UInt(width),
            rowBytes: MemoryLayout<Float>.size * width * components
        )
    }
}
