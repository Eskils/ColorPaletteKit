//
//  ImagePaletteComputationMethod.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 29/09/2025.
//

import CoreGraphics

@available(macOS 13.0, iOS 16.0, *)
public enum ImagePaletteComputationMethod {
    case kMeans(KMeans)
}

@available(macOS 13.0, iOS 16.0, *)
extension ImagePaletteComputationMethod {
    public struct KMeans {
        public let maximumIterations: Int
        public let tolerance: Int
        
        public init(maximumIterations: Int, tolerance: Int) {
            self.maximumIterations = maximumIterations
            self.tolerance = tolerance
        }
        
        public init() {
            self.init(
                maximumIterations: 50,
                tolerance: 10
            )
        }
    }
}
