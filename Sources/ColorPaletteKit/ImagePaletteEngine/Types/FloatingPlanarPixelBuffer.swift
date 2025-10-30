//
//  FloatingPlanarPixelBuffer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 28/09/2025.
//

import Accelerate

struct FloatingPlanarPixelBuffer: ~Copyable {
    let storage: UnsafeMutableBufferPointer<Float>
    var buffer: vImage_Buffer
    
    init(width: Int, height: Int) {
        self.storage = UnsafeMutableBufferPointer<Float>.allocate(capacity: width * height)
        self.buffer = vImage_Buffer(
            data: storage.baseAddress!,
            height: UInt(height),
            width: UInt(width),
            rowBytes: width * MemoryLayout<Float>.stride
        )
    }
    
    deinit {
        storage.deallocate()
    }
}
