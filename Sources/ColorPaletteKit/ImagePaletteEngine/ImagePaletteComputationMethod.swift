//
//  ImagePaletteComputationMethod.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 29/09/2025.
//

import CoreGraphics

/// Possible methods of extracting the dominant colors of an image.
@available(macOS 11.0, iOS 14.0, *)
public enum ImagePaletteComputationMethod {
    /// Use kMeans to find the dominant colors.
    /// More accurate, takes a significant time to compute.
    case kMeans(KMeans)
    /// Measure the color at points in the image that are equally spaced.
    /// Less accurate, takes little time to compute.
    case equallySpacedSamples
}

@available(macOS 11.0, iOS 14.0, *)
extension ImagePaletteComputationMethod {
    func computer(cgImage: CGImage) throws(ImagePaletteComputationError) -> any ImagePaletteComputer {
        switch self {
        case .kMeans(let kMeans):
            try KMeansImagePaletteComputer(cgImage: cgImage, parameters: kMeans)
        case .equallySpacedSamples:
            try EquallySpacedSamplesPaletteComputer(cgImage: cgImage, parameters: ())
        }
    }
    
    func computer(image: ImageDataDescription) throws(ImagePaletteComputationError) -> any ImagePaletteComputer {
        switch self {
        case .kMeans(let kMeans):
            try KMeansImagePaletteComputer(image: image, parameters: kMeans)
        case .equallySpacedSamples:
            try EquallySpacedSamplesPaletteComputer(image: image, parameters: ())
        }
    }
}

@available(macOS 11.0, iOS 14.0, *)
extension ImagePaletteComputationMethod {
    public struct KMeans {
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
