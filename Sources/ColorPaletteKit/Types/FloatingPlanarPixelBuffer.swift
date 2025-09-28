//
//  FloatingPlanarPixelBuffer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 28/09/2025.
//

import Accelerate

@available(macOS 13.0, iOS 16.0, *)
struct FloatingPlanarPixelBuffer: ~Copyable {
    let storage: UnsafeMutableBufferPointer<Float>
    let buffer: vImage.PixelBuffer<vImage.PlanarF>
    
    init(width: Int, height: Int) {
        self.storage = UnsafeMutableBufferPointer<Float>.allocate(capacity: width * height)
        self.buffer = vImage.PixelBuffer<vImage.PlanarF>(
            data: storage.baseAddress!,
            width: width,
            height: height,
            byteCountPerRow: width * MemoryLayout<Float>.stride)
    }
    
    deinit {
        storage.deallocate()
    }
}
