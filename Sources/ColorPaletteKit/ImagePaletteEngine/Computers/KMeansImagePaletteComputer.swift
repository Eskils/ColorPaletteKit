//
//  KMeansImagePaletteComputer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 27/09/2025.
//

import CoreGraphics
import Accelerate

@available(macOS 13.0, iOS 16.0, *)
final class KMeansImagePaletteComputer: ImagePaletteComputer {
    private let cgImage: CGImage
    private let imageFormat: vImage_CGImageFormat
    
    private let width: Int
    private let height: Int
    private let size: Int
    
    private let redBuffer: FloatingPlanarPixelBuffer
    private let greenBuffer: FloatingPlanarPixelBuffer
    private let blueBuffer: FloatingPlanarPixelBuffer
    
    private let centroidIndicesDescriptor: BNNSNDArrayDescriptor
    private var defaultParameters: ImagePaletteComputationMethod.KMeans = .init()
    
    public init(cgImage: CGImage) throws(ImagePaletteComputationError) {
        self.cgImage = cgImage
        guard var imageFormat = vImage_CGImageFormat(
            bitsPerComponent: 32,
            bitsPerPixel: 32 * 3,
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(
                rawValue: kCGBitmapByteOrder32Host.rawValue |
                CGBitmapInfo.floatComponents.rawValue |
                CGImageAlphaInfo.none.rawValue)) else {
            throw .cannotMakeImageFormat
        }
        self.width = cgImage.width
        self.height = cgImage.height
        self.size = width * height
        self.redBuffer = FloatingPlanarPixelBuffer(width: width, height: height)
        self.greenBuffer = FloatingPlanarPixelBuffer(width: width, height: height)
        self.blueBuffer = FloatingPlanarPixelBuffer(width: width, height: height)

        let rgbSources: [vImage.PixelBuffer<vImage.PlanarF>]
        do {
            let interleaved = try vImage.PixelBuffer<vImage.InterleavedFx3>(
                cgImage: cgImage,
                cgImageFormat: &imageFormat
            )
            rgbSources = interleaved.planarBuffers()
            
            rgbSources[0].scale(destination: redBuffer.buffer)
            rgbSources[1].scale(destination: greenBuffer.buffer)
            rgbSources[2].scale(destination: blueBuffer.buffer)
        } catch {
            throw .cannotExtractImageData
        }
        self.imageFormat = imageFormat
        
        centroidIndicesDescriptor = BNNSNDArrayDescriptor.allocateUninitialized(
            scalarType: Int32.self,
            shape: .matrixRowMajor(size, 1))
    }
    
    public convenience init(cgImage: CGImage, parameters: ImagePaletteComputationMethod.KMeans) throws(ImagePaletteComputationError) {
        try self.init(cgImage: cgImage)
        self.defaultParameters = parameters
    }
    
    public func dominantColors(amount: Int) -> [SIMD3<Float>] {
        dominantColors(
            amount: amount,
            maximumIterations: defaultParameters.maximumIterations,
            tolerance: defaultParameters.tolerance
        )
    }
    
    public func dominantColors(
        amount: Int = 4,
        maximumIterations: Int = 50,
        tolerance: Int = 10
    ) -> [SIMD3<Float>] {
        let distances = UnsafeMutableBufferPointer<Float>.allocate(capacity: size * amount)
        let temporaryReds = UnsafeMutablePointer<Float>.allocate(capacity: size)
        let temporaryGreens = UnsafeMutablePointer<Float>.allocate(capacity: size)
        let temporaryBlues = UnsafeMutablePointer<Float>.allocate(capacity: size)
        
        defer {
            distances.deallocate()
            temporaryReds.deallocate()
            temporaryGreens.deallocate()
            temporaryBlues.deallocate()
        }
        
        var centroids = makeCentroids(amount: amount, temporaryBuffer: distances)
        
        var converged = false
        var iterationCount = 0
        
        while !converged && iterationCount < maximumIterations {
            converged = stepCentroids(
                centroids: &centroids,
                temporaryReds: temporaryReds,
                temporaryGreens: temporaryGreens,
                temporaryBlues: temporaryBlues,
                distances: distances,
                tolerance: tolerance
            )
            iterationCount += 1
        }
        
        return centroids.map { $0.color }
    }
    
    private func makeCentroids(amount: Int, temporaryBuffer: UnsafeMutableBufferPointer<Float>) -> [Centroid] {
        var centroids = [Centroid]()
        
        let stride = size / (amount + 2)
        for i in 0..<amount {
            let randomIndex = (i + 1) * stride
            
            centroids.append(
                Centroid(
                    red: redBuffer.storage[randomIndex],
                    green: greenBuffer.storage[randomIndex],
                    blue: blueBuffer.storage[randomIndex]
                )
            )
        }
        
        return centroids
    }
    
    private func stepCentroids(
        centroids: inout [Centroid],
        temporaryReds: UnsafeMutablePointer<Float>,
        temporaryGreens: UnsafeMutablePointer<Float>,
        temporaryBlues: UnsafeMutablePointer<Float>,
        distances: UnsafeMutableBufferPointer<Float>,
        tolerance: Int = 10
    ) -> Bool {
        let pixelCounts = centroids.map { return $0.pixelCount }
        
        populateDistances(
            centroids: centroids,
            temporaryReds: temporaryReds,
            temporaryGreens: temporaryGreens,
            temporaryBlues: temporaryBlues,
            distances: distances.baseAddress!
        )
        
        let centroidIndices = makeCentroidIndices(amount: centroids.count, distances: distances)
        
        for centroid in centroids.enumerated() {
            let indices = centroidIndices.enumerated().filter {
                $0.element == centroid.offset
            }.map {
                UInt($0.offset + 1)
            }
            
            centroids[centroid.offset].pixelCount = indices.count
            
            if !indices.isEmpty {
                let gatheredRed = vDSP.gather(redBuffer.storage,
                                              indices: indices)
                
                let gatheredGreen = vDSP.gather(greenBuffer.storage,
                                                indices: indices)
                
                let gatheredBlue = vDSP.gather(blueBuffer.storage,
                                               indices: indices)
                
                let color: SIMD3<Float> = [
                    vDSP.mean(gatheredRed),
                    vDSP.mean(gatheredGreen),
                    vDSP.mean(gatheredBlue),
                ]
                
                centroids[centroid.offset].color = color
            }
        }
        
        return pixelCounts.elementsEqual(centroids.map { return $0.pixelCount }) { a, b in
            return abs(a - b) < tolerance
        }
    }
    
    private func populateDistances(
        centroids: [Centroid],
        temporaryReds: UnsafeMutablePointer<Float>,
        temporaryGreens: UnsafeMutablePointer<Float>,
        temporaryBlues: UnsafeMutablePointer<Float>,
        distances: UnsafeMutablePointer<Float>
    ) {
        for (i, centroid) in centroids.enumerated() {
            distanceSquared(
                reds: redBuffer.storage.baseAddress!,
                greens: greenBuffer.storage.baseAddress!,
                blues: blueBuffer.storage.baseAddress!,
                centroid: centroid.color,
                size: size,
                temporaryReds: temporaryReds,
                temporaryGreens: temporaryBlues,
                temporaryBlues: temporaryGreens,
                result: distances.advanced(by: size * i)
            )
        }
    }
    
    /// Returns the index of the closest centroid for each color.
    private func makeCentroidIndices(amount: Int, distances: UnsafeMutableBufferPointer<Float>) -> [Int32] {
        let distancesDescriptor = BNNSNDArrayDescriptor(
            data: distances,
            shape: .matrixRowMajor(size, amount)
        )!
        
        let reductionLayer = BNNS.ReductionLayer(
            function: .argMin,
            input: distancesDescriptor,
            output: centroidIndicesDescriptor,
            weights: nil
        )
        
        try! reductionLayer?.apply(
            batchSize: 1,
            input: distancesDescriptor,
            output: centroidIndicesDescriptor
        )
        
        return centroidIndicesDescriptor.makeArray(of: Int32.self)!
    }
    
    private func distanceSquared(
        reds: UnsafePointer<Float>,
        greens: UnsafePointer<Float>,
        blues: UnsafePointer<Float>,
        centroid: SIMD3<Float>,
        size: Int,
        temporaryReds: UnsafeMutablePointer<Float>,
        temporaryGreens: UnsafeMutablePointer<Float>,
        temporaryBlues: UnsafeMutablePointer<Float>,
        result: UnsafeMutablePointer<Float>
    ) {
        let length = vDSP_Length(size)
        
        vDSP_vsub(reds, 1, [centroid.x], 0, temporaryReds, 1, length)
        vDSP_vsq(temporaryReds, 1, temporaryReds, 1, length)
        
        vDSP_vsub(greens, 1, [centroid.y], 0, temporaryGreens, 1, length)
        vDSP_vsq(temporaryGreens, 1, temporaryGreens, 1, length)
        
        vDSP_vsub(blues, 1, [centroid.z], 0, temporaryBlues, 1, length)
        vDSP_vsq(temporaryBlues, 1, temporaryBlues, 1, length)
        
        vDSP_vadd(temporaryReds, 1, temporaryGreens, 1, result, 1, length)
        vDSP_vadd(result, 1, temporaryBlues, 1, result, 1, length)
    }
}

@available(macOS 13.0, iOS 16.0, *)
extension KMeansImagePaletteComputer {
    struct Centroid {
        var color: SIMD3<Float>
        var pixelCount = 0
    }
}

@available(macOS 13.0, iOS 16.0, *)
extension KMeansImagePaletteComputer.Centroid {
    init(red: Float, green: Float, blue: Float) {
        self.init(color: [red, green, blue])
    }
    
    var red: Float {
        color.x
    }
    
    var green: Float {
        color.y
    }
    
    var blue: Float {
        color.z
    }
}
