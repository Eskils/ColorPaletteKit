//
//  EquallySpacedSamplesPaletteComputerTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 05/10/2025.
//

import Foundation
import CoreGraphics
@testable import ColorPaletteKit
import Testing
import simd
import Accelerate
import TestHelpers

private let testsDirectory = URL(fileURLWithPath: #filePath + "/../../").standardizedFileURL

struct EquallySpacedSamplesPaletteComputerTests {
    let snapshot = TestSnapshotContext(testsDirectory: testsDirectory)
    let paletteImageEngine = PaletteImageEngine(kind: .grid)
    let paletteImageSize = CGSize(width: 40, height: 40)
    
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory.path)/\(directory)/\(name)"
    }
    
    @Test
    func findingFewDominantColorsInLeaf() throws {
        let expectedColors = [
            SIMD3<Float>(0.28235295, 0.3019608, 0.0),
            SIMD3<Float>(0.3137255, 0.37254903, 0.0),
            SIMD3<Float>(0.36862746, 0.38823533, 0.027450982),
            SIMD3<Float>(0.7490196, 0.75294125, 0.43921572)
        ]
        
        let leaf = try ImageFileInterface.image(atPath: filePath(name: "leaf.jpg", directory: "TestAssets"))
        let imagePaletteDescription = try EquallySpacedSamplesPaletteComputer(cgImage: leaf)
        let colors = imagePaletteDescription.dominantColors(amount: 4)
        
        #expect(
            isWithinAcceptedThreshold(
                colors: colors,
                expectedColors: expectedColors,
                threshold: 0.1
            )
        )
    }
    
    @Test
    func findingFewDominantColorsInMountains() throws {
        let expectedColors = [
            SIMD3<Float>(0.2509804, 0.3254902, 0.48235297),
            SIMD3<Float>(0.28627452, 0.36078432, 0.5176471),
            SIMD3<Float>(0.58431375, 0.6392157, 0.7411765),
            SIMD3<Float>(0.8000001, 0.7843138, 0.7411765),
        ]
        
        let mountains = try ImageFileInterface.image(atPath: filePath(name: "mountains.jpg", directory: "TestAssets"))
        let imagePaletteDescription = try EquallySpacedSamplesPaletteComputer(cgImage: mountains)
        let colors = imagePaletteDescription.dominantColors(amount: 4)
        
        #expect(
            isWithinAcceptedThreshold(
                colors: colors,
                expectedColors: expectedColors,
                threshold: 0.1
            )
        )
    }
    
    @Test
    func findingFewDominantColorsInSunset() throws {
        let expectedColors = [
            SIMD3<Float>(0.24705884, 0.24705884, 0.62352943),
            SIMD3<Float>(0.24705884, 0.25490198, 0.5882353),
            SIMD3<Float>(0.34117648, 0.32156864, 0.40784317),
            SIMD3<Float>(1.0, 0.57254905, 0.3921569)
        ]
        
        let sunset = try ImageFileInterface.image(atPath: filePath(name: "sunset.jpg", directory: "TestAssets"))
        let imagePaletteDescription = try EquallySpacedSamplesPaletteComputer(cgImage: sunset)
        let colors = imagePaletteDescription.dominantColors(amount: 4)
        
        #expect(
            isWithinAcceptedThreshold(
                colors: colors,
                expectedColors: expectedColors,
                threshold: 0.1
            )
        )
    }
    
    @Test
    func fewDominantColorsInLeafSnapshot() async throws {
        try await snapshot.assertSnapshot(name: "equally-spaced-leaf-4-colors") {
            let leaf = try ImageFileInterface.image(atPath: filePath(name: "leaf.jpg", directory: "TestAssets"))
            let imagePaletteDescription = try EquallySpacedSamplesPaletteComputer(cgImage: leaf)
            let colors = imagePaletteDescription.dominantColors(amount: 4)
            return try paletteImageEngine.render(colors: colors, size: paletteImageSize)
        }
    }
    
    @Test
    func fewDominantColorsInMountainsSnapshot() async throws {
        try await snapshot.assertSnapshot(name: "equally-spaced-mountains-4-colors") {
            let leaf = try ImageFileInterface.image(atPath: filePath(name: "mountains.jpg", directory: "TestAssets"))
            let imagePaletteDescription = try EquallySpacedSamplesPaletteComputer(cgImage: leaf)
            let colors = imagePaletteDescription.dominantColors(amount: 4)
            return try paletteImageEngine.render(colors: colors, size: paletteImageSize)
        }
    }
    
    @Test
    func fewDominantColorsInSunsetSnapshot() async throws {
        try await snapshot.assertSnapshot(name: "equally-spaced-sunset-4-colors") {
            let leaf = try ImageFileInterface.image(atPath: filePath(name: "sunset.jpg", directory: "TestAssets"))
            let imagePaletteDescription = try EquallySpacedSamplesPaletteComputer(cgImage: leaf)
            let colors = imagePaletteDescription.dominantColors(amount: 4)
            return try paletteImageEngine.render(colors: colors, size: paletteImageSize)
        }
    }
}
