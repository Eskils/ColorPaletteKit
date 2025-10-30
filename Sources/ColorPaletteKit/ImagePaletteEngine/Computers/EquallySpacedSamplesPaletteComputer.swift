//
//  EquallySpacedSamplesPaletteComputer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 04/10/2025.
//

import CoreGraphics
import Accelerate

final class EquallySpacedSamplesPaletteComputer: ImagePaletteComputer {
    private let imageBuffer: vImage_Buffer
    private let imageData: UnsafeMutablePointer<Float>
    
    private let width: UInt
    private let height: UInt
    private let size: UInt
    private let components: Int
    
    init(imageBuffer: vImage_Buffer, components: Int) {
        self.imageBuffer = imageBuffer
        self.components = components
        self.imageData = imageBuffer.data.assumingMemoryBound(to: Float.self)
        self.width = imageBuffer.width
        self.height = imageBuffer.height
        self.size = width * height
    }
    
    convenience init(cgImage: CGImage) throws(ImagePaletteComputationError) {
        guard let imageFormat = vImage_CGImageFormat(
            bitsPerComponent: 32,
            bitsPerPixel: 32 * 3,
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(
                rawValue: kCGBitmapByteOrder32Host.rawValue |
                CGBitmapInfo.floatComponents.rawValue |
                CGImageAlphaInfo.none.rawValue
            )
        ) else {
            throw .cannotMakeImageFormat
        }
        
        do {
            let imageBuffer = try vImage_Buffer(cgImage: cgImage, format: imageFormat)
            self.init(imageBuffer: imageBuffer, components: 3)
        } catch {
            throw .cannotExtractImageData
        }
    }
    
    convenience init(image: ImageDataDescription, parameters: Void) throws(ImagePaletteComputationError) {
        let imageBuffer = image.imageBuffer()
        self.init(imageBuffer: imageBuffer, components: image.components)
    }
    
    convenience init(cgImage: CGImage, parameters: Void) throws(ImagePaletteComputationError) {
        try self.init(cgImage: cgImage)
    }
    
    func dominantColors(amount: Int) -> [SIMD3<Float>] {
        let unsignedAmount = UInt(amount)
        let stride = size / (unsignedAmount + 2)
        return (0..<unsignedAmount).map { i in
            let randomIndex = (i + 1) * stride
            let red = imageData[Int(randomIndex) * components + 0]
            let green = imageData[Int(randomIndex) * components + 1]
            let blue = imageData[Int(randomIndex) * components + 2]
            return [red, green, blue]
        }
    }
}
