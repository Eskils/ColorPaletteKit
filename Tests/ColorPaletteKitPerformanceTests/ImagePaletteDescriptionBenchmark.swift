//
//  ImagePaletteDescriptionBenchmark.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 28/09/2025.
//

import Foundation
import Testing
import ColorPaletteKit
import TestHelpers

struct ImagePaletteDescriptionBenchmark {
    let testsDirectory = URL(fileURLWithPath: #filePath + "/../../").standardizedFileURL.path
    
    func filePath(name: String, directory: String) -> String {
        "\(testsDirectory)/\(directory)/\(name)"
    }
    
    @Test
    func durationOfInitialization() throws {
        let sunset = try ImageFileInterface.image(atPath: filePath(name: "sunset.jpg", directory: "TestAssets"))
        let start = CFAbsoluteTimeGetCurrent()
        _ = ImagePaletteDescription(cgImage: sunset)
        let end = CFAbsoluteTimeGetCurrent()
        let runtime =  end - start
        print(runtime)
        #expect(runtime < 0.05)
    }
    
    @Test
    func durationForFindingManyDominantColorsWithDefaultTolerance() throws {
        let runtime = try measureRuntimeOfDominantColorsComputation(
            amountOfColors: 256,
            maximumIterations: 50,
            tolerance: 10
        )
        print(runtime)
        #expect(runtime < 8.5)
    }
    
    @Test
    func durationForFindingHalfDominantColorsWithDefaultTolerance() throws {
        let runtime = try measureRuntimeOfDominantColorsComputation(
            amountOfColors: 128,
            maximumIterations: 50,
            tolerance: 10
        )
        print(runtime)
        #expect(runtime < 4.5)
    }
    
    @Test
    func durationForFindingQuarterDominantColorsWithDefaultTolerance() throws {
        let runtime = try measureRuntimeOfDominantColorsComputation(
            amountOfColors: 64,
            maximumIterations: 50,
            tolerance: 10
        )
        print(runtime)
        #expect(runtime < 2.5)
    }
    
    @Test
    func durationForFindingEighthDominantColorsWithDefaultTolerance() throws {
        let runtime = try measureRuntimeOfDominantColorsComputation(
            amountOfColors: 32,
            maximumIterations: 50,
            tolerance: 10
        )
        print(runtime)
        #expect(runtime < 1.5)
    }
    
    @Test
    func durationForFindingSixteenthDominantColorsWithDefaultTolerance() throws {
        let runtime = try measureRuntimeOfDominantColorsComputation(
            amountOfColors: 16,
            maximumIterations: 50,
            tolerance: 10
        )
        print(runtime)
        #expect(runtime < 1)
    }
    
    @Test
    func durationForFindingFewDominantColorsWithDefaultTolerance() throws {
        let runtime = try measureRuntimeOfDominantColorsComputation(
            amountOfColors: 8,
            maximumIterations: 50,
            tolerance: 10
        )
        print(runtime)
        #expect(runtime < 0.7)
    }
    
    private func measureRuntimeOfDominantColorsComputation(
        amountOfColors: Int,
        maximumIterations: Int = 50,
        tolerance: Int = 10
    ) throws -> TimeInterval {
        let sunset = try ImageFileInterface.image(atPath: filePath(name: "sunset.jpg", directory: "TestAssets"))
        let imagePaletteDescription = ImagePaletteDescription(cgImage: sunset)
        let start = CFAbsoluteTimeGetCurrent()
        _ = imagePaletteDescription.dominantColors(
            amount: amountOfColors,
            maximumIterations: maximumIterations,
            tolerance: tolerance
        )
        let end = CFAbsoluteTimeGetCurrent()
        return end - start
    }
}
