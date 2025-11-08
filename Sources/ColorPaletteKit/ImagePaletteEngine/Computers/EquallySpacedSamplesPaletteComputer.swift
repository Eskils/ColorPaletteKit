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
    private var defaultParameters: EquallySpacedSamples = .init()
    private var isNormalized = true
    
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
    
    convenience init(image: ImageDataDescription, parameters: EquallySpacedSamples) throws(ImagePaletteComputationError) {
        let imageBuffer = image.imageBuffer()
        self.init(imageBuffer: imageBuffer, components: image.components)
        self.defaultParameters = parameters
        self.isNormalized = image.isNormalized
    }
    
    convenience init(cgImage: CGImage, parameters: EquallySpacedSamples) throws(ImagePaletteComputationError) {
        try self.init(cgImage: cgImage)
        self.defaultParameters = parameters
    }
    
    func dominantColors(amount: Int) -> [SIMD3<Float>] {
        dominantColors(
            amount: amount,
            reduceSimilarColorsThreshold: defaultParameters.reduceSimilarColorsThreshold
        )
    }
    
    func dominantColors(amount: Int, reduceSimilarColorsThreshold: Int) -> [SIMD3<Float>] {
        let xStep = Int(width) / (amount + 1)
        let yStep = Int(height) / (amount + 1)
        let attempts = [
            (x: xStep, y: 0),
            (x: -xStep, y: 0),
            (x: 0, y: yStep),
            (x: 0, y: -yStep),
        ]
        let reduceSimilarColors = amount < reduceSimilarColorsThreshold
        let unsignedAmount = UInt(amount)
        let stride = Int(size / (unsignedAmount + 2))
        var registeredColors = Set<Int>(minimumCapacity: min(reduceSimilarColorsThreshold, amount))
        return (0..<amount).map { i in
            let sampleIndex = (i + 1) * stride
            let color = color(at: sampleIndex)
            let colorIndex = colorSimilarityIndex(of: color)
            if !reduceSimilarColors || !registeredColors.contains(colorIndex) {
                if reduceSimilarColors {
                    registeredColors.insert(colorIndex)
                }
                
                return color
            } else {
                for attempt in attempts {
                    let color = colorAround(sampleIndex: sampleIndex, offsetX: attempt.x, y: attempt.y)
                    let colorIndex = colorSimilarityIndex(of: color)
                    if !registeredColors.contains(colorIndex) {
                        registeredColors.insert(colorIndex)
                        return color
                    }
                }
                
                return color
            }
        }
    }
    
    private func colorAround(sampleIndex: Int, offsetX x: Int, y: Int) -> SIMD3<Float> {
        let yOffset = y * Int(width)
        let index = sampleIndex + yOffset + x
        let clampedIndex = min(max(index, 0), Int(size) - 1)
        return color(at: clampedIndex)
    }
    
    private func color(at sampleIndex: Int) -> SIMD3<Float> {
        let red = imageData[sampleIndex * components + 0]
        let green = imageData[sampleIndex * components + 1]
        let blue = imageData[sampleIndex * components + 2]
        return [red, green, blue]
    }
    
    private func colorSimilarityIndex(of color: SIMD3<Float>) -> Int {
        var step: Float = 8
        if !isNormalized {
            step /= 255
        }
        let red = Int(color.x * step)
        let green = Int(color.y * step)
        let blue = Int(color.z * step)
        return red << 2 + green << 1 + blue
    }
}
