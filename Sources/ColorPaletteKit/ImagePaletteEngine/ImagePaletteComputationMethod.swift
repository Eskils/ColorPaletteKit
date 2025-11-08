//
//  ImagePaletteComputationMethod.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 29/09/2025.
//

import CoreGraphics

/// Possible methods of extracting the dominant colors of an image.
@available(macOS 11.0, iOS 14.0, *)
public enum ImagePaletteComputationMethod: Hashable, Sendable {
    /// Use kMeans to find the dominant colors.
    /// More accurate, takes a significant time to compute.
    case kMeans(KMeans)
    /// Measure the color at points in the image that are equally spaced.
    /// Less accurate, takes little time to compute.
    case equallySpacedSamples(EquallySpacedSamples)
}

@available(macOS 11.0, iOS 14.0, *)
extension ImagePaletteComputationMethod {
    /// Use kMeans to find the dominant colors.
    /// More accurate, takes a significant time to compute.
    public static let kMeans = ImagePaletteComputationMethod.kMeans(KMeans())
    
    /// Measure the color at points in the image that are equally spaced.
    /// Less accurate, takes little time to compute.
    public static let equallySpacedSamples = ImagePaletteComputationMethod.equallySpacedSamples(EquallySpacedSamples())
}

@available(macOS 11.0, iOS 14.0, *)
extension ImagePaletteComputationMethod {
    func computer(cgImage: CGImage) throws(ImagePaletteComputationError) -> any ImagePaletteComputer {
        switch self {
        case .kMeans(let parameters):
            try KMeansImagePaletteComputer(cgImage: cgImage, parameters: parameters)
        case .equallySpacedSamples(let parameters):
            try EquallySpacedSamplesPaletteComputer(cgImage: cgImage, parameters: parameters)
        }
    }
    
    func computer(image: ImageDataDescription) throws(ImagePaletteComputationError) -> any ImagePaletteComputer {
        switch self {
        case .kMeans(let parameters):
            try KMeansImagePaletteComputer(image: image, parameters: parameters)
        case .equallySpacedSamples(let parameters):
            try EquallySpacedSamplesPaletteComputer(image: image, parameters: parameters)
        }
    }
}

@available(macOS 11.0, iOS 14.0, *)
extension ImagePaletteComputationMethod {
    public struct KMeans: Hashable, Sendable {
        /// The maximum number of iterations before the computation gives its result.
        /// Reducing this number will decrease the maximum time to compute a result.
        /// Default is ``defaultMaximumIterations``.
        public let maximumIterations: Int
        /// The accepted error in the result before the computation gives its result.
        /// Increasing this number may reduce the time it takes to compute a result.
        /// Default is ``defaultTolerance``.
        public let tolerance: Int
        
        public init(maximumIterations: Int, tolerance: Int) {
            self.maximumIterations = maximumIterations
            self.tolerance = tolerance
        }
        
        public init() {
            self.init(
                maximumIterations: Self.defaultMaximumIterations,
                tolerance: Self.defaultTolerance
            )
        }
        
        public static let defaultMaximumIterations = 50
        public static let defaultTolerance = 10
    }
}

public struct EquallySpacedSamples: Hashable, Sendable {
    /// The number of colors below which the computation will also consider
    /// neighbouring colors to find colors that are not the same.
    /// Set to `0` to disable.
    /// Default is `defaultReduceSimilarColorsThreshold`
    public let reduceSimilarColorsThreshold: Int
    
    public init(reduceSimilarColorsThreshold: Int) {
        self.reduceSimilarColorsThreshold = reduceSimilarColorsThreshold
    }
    
    public init() {
        self.init(
            reduceSimilarColorsThreshold: Self.defaultReduceSimilarColorsThreshold
        )
    }
    
    public static let defaultReduceSimilarColorsThreshold = 32
}
