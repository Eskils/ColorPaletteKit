//
//  SpectrumPaletteImageRendererTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

import Testing
import CoreGraphics
@testable import ColorPaletteKit
import Foundation
import TestHelpers

struct SpectrumPaletteImageRendererTests {
    let snapshot = TestSnapshotContext(testsDirectory: URL(fileURLWithPath: #filePath + "/../../../").standardizedFileURL)
    
    let renderer = SpectrumPaletteImageRenderer()
    let size = CGSize(width: 40, height: 40)
    
    @Test
    func noColorsGivesClearImage() async throws {
        try await snapshot.assertSnapshot(name: "spectrum-palette-empty") {
            try renderer.render(
                colors: [],
                size: size
            )
        }
    }
    
    @Test
    func oneColorFillsWholeImage() async throws {
        try await snapshot.assertSnapshot(name: "spectrum-palette-one-color") {
            try renderer.render(
                colors: [
                    [0.9, 0.4, 0.5]
                ],
                size: size
            )
        }
    }
    
    @Test
    func twoColorsStackEquallyInHorizontalDirection() async throws {
        try await snapshot.assertSnapshot(name: "spectrum-palette-two-colors") {
            try renderer.render(
                colors: [
                    [0.9, 0.2, 0.3],
                    [0.3, 0.2, 0.9]
                ],
                size: size
            )
        }
    }
    
    @Test
    func fiveColorsStackEquallyInHorizontalDirection() async throws {
        try await snapshot.assertSnapshot(name: "spectrum-palette-five-colors") {
            try renderer.render(
                colors: [
                    [0.1, 0.2, 0.3],
                    [0.9, 0.6, 0.4],
                    [0.3, 0.2, 0.1],
                    [0.5, 0.7, 0.9],
                    [0.8, 0.9, 0.3],
                ],
                size: size
            )
        }
    }
    
    @Test
    func sixColorsStackEquallyInHorizontalDirection() async throws {
        try await snapshot.assertSnapshot(name: "spectrum-palette-six-colors") {
            try renderer.render(
                colors: [
                    [0.1, 0.2, 0.3],
                    [0.9, 0.6, 0.4],
                    [0.3, 0.2, 0.1],
                    [0.5, 0.7, 0.9],
                    [0.8, 0.9, 0.3],
                    [0.7, 0.1, 0.4],
                ],
                size: size
            )
        }
    }
}
