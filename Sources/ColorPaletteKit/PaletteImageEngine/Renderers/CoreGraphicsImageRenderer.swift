//
//  CoreGraphicsImageRenderer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

import CoreGraphics

struct CoreGraphicsImageRenderer {
    let context: CGContext
    
    init(size: CGSize) throws(CoreGraphicsImageRendererError) {
        let width = Int(size.width)
        let height = Int(size.height)
        let components = 4
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: components * width,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw .cannotMakeCoreGraphicsContext
        }
        self.context = context
    }
    
    func image(operations: (CGContext) -> Void) throws(CoreGraphicsImageRendererError) -> CGImage {
        operations(context)
        guard let image = context.makeImage() else {
            throw .cannotMakeImage
        }
        return image
    }
}

enum CoreGraphicsImageRendererError: Error {
    case cannotMakeCoreGraphicsContext
    case cannotMakeImage
}
