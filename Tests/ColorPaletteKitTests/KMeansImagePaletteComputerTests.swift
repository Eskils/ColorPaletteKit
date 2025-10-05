//
//  KMeansImagePaletteComputerTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 28/09/2025.
//

import Foundation
import CoreGraphics
import ColorPaletteKit
import Testing
import simd
import Accelerate
import TestHelpers

private let testsDirectory = URL(fileURLWithPath: #filePath + "/../../").standardizedFileURL

struct KMeansImagePaletteComputerTests {
    let snapshot = TestSnapshotContext(testsDirectory: testsDirectory)
    let paletteImageEngine = PaletteImageEngine(kind: .grid)
    let paletteImageSize = CGSize(width: 40, height: 40)
    
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory.path)/\(directory)/\(name)"
    }
    
    func sort(colors: [SIMD3<Float>]) -> [SIMD3<Float>] {
        colors.sorted {
            $0.x < $1.x
        }
    }
    
    @Test
    func findingFewDominantColorsInLeaf() throws {
        let expectedColors = [
            SIMD3<Float>(0.23940559, 0.28212035, 0.008949555),
            SIMD3<Float>(0.41786635, 0.46012294, 0.03973621),
            SIMD3<Float>(0.6331294, 0.6580225, 0.24873522),
            SIMD3<Float>(0.8355591, 0.8345491, 0.605728),
        ]
        
        let leaf = try ImageFileInterface.image(atPath: filePath(name: "leaf.jpg", directory: "TestAssets"))
        let imagePaletteDescription = try KMeansImagePaletteComputer(cgImage: leaf)
        let colors = imagePaletteDescription.dominantColors(amount: 4, maximumIterations: 10, tolerance: 10)
        
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
            SIMD3<Float>(0.08997959, 0.16401778, 0.29328173),
            SIMD3<Float>(0.25269696, 0.3357967, 0.49021384),
            SIMD3<Float>(0.63120484, 0.67951775, 0.74521655),
            SIMD3<Float>(0.87096965, 0.83473915, 0.788319)
        ]
        
        let mountains = try ImageFileInterface.image(atPath: filePath(name: "mountains.jpg", directory: "TestAssets"))
        let imagePaletteDescription = try KMeansImagePaletteComputer(cgImage: mountains)
        let colors = imagePaletteDescription.dominantColors(amount: 4, maximumIterations: 10, tolerance: 10)
        
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
            SIMD3<Float>(0.09141211, 0.07860868, 0.1610566),
            SIMD3<Float>(0.14989123, 0.24892537, 0.6594368),
            SIMD3<Float>(0.39416814, 0.32713065, 0.5452053),
            SIMD3<Float>(0.91890585, 0.6635338, 0.6107377),
        ]
        
        let sunset = try ImageFileInterface.image(atPath: filePath(name: "sunset.jpg", directory: "TestAssets"))
        let imagePaletteDescription = try KMeansImagePaletteComputer(cgImage: sunset)
        let colors = imagePaletteDescription.dominantColors(amount: 4, maximumIterations: 10, tolerance: 10)
        
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
        try await snapshot.assertSnapshot(name: "k-means-leaf-4-colors") {
            let leaf = try ImageFileInterface.image(atPath: filePath(name: "leaf.jpg", directory: "TestAssets"))
            let imagePaletteDescription = try KMeansImagePaletteComputer(cgImage: leaf)
            let colors = imagePaletteDescription.dominantColors(amount: 4, maximumIterations: 10, tolerance: 10)
            return try paletteImageEngine.render(colors: colors, size: paletteImageSize)
        }
    }
    
    @Test
    func fewDominantColorsInMountainsSnapshot() async throws {
        try await snapshot.assertSnapshot(name: "k-means-mountains-4-colors") {
            let leaf = try ImageFileInterface.image(atPath: filePath(name: "mountains.jpg", directory: "TestAssets"))
            let imagePaletteDescription = try KMeansImagePaletteComputer(cgImage: leaf)
            let colors = imagePaletteDescription.dominantColors(amount: 4, maximumIterations: 10, tolerance: 10)
            return try paletteImageEngine.render(colors: colors, size: paletteImageSize)
        }
    }
    
    @Test
    func fewDominantColorsInSunsetSnapshot() async throws {
        try await snapshot.assertSnapshot(name: "k-means-sunset-4-colors") {
            let leaf = try ImageFileInterface.image(atPath: filePath(name: "sunset.jpg", directory: "TestAssets"))
            let imagePaletteDescription = try KMeansImagePaletteComputer(cgImage: leaf)
            let colors = imagePaletteDescription.dominantColors(amount: 4, maximumIterations: 10, tolerance: 10)
            return try paletteImageEngine.render(colors: colors, size: paletteImageSize)
        }
    }
    
    private func isWithinAcceptedThreshold(colors: [SIMD3<Float>], expectedColors: [SIMD3<Float>], threshold: Float) -> Bool {
        let sortedColors = sort(colors: colors)
        let difference = sortedColors.enumerated().map { i, color in
            let expectedColor = expectedColors[i]
            return distance(color, expectedColor)
        }
        let isWithinAcceptedThreshold = difference.allSatisfy { $0 < threshold }
        if !isWithinAcceptedThreshold {
            print("Is not within accepted threshold")
            print("Distances:", difference)
            print("Dominant colors", sortedColors)
            print("Required threshold", difference.max() ?? 0)
        }
        return isWithinAcceptedThreshold
    }
}
