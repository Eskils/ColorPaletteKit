//
//  GridPaletteImageRendererTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

import Testing
import CoreGraphics
@testable import ColorPaletteKit
import Foundation
import TestHelpers

struct GridPaletteImageRendererTests {
    let snapshot = TestSnapshotContext(testsDirectory: URL(fileURLWithPath: #filePath + "/../../../").standardizedFileURL)
    
    let renderer = GridPaletteImageRenderer(maxColumns: 6)
    let size = CGSize(width: 40, height: 40)
    
    @Test
    func noColorsGivesClearImage() async throws {
        try await snapshot.assertSnapshot(name: "grid-palette-empty") {
            try renderer.render(
                colors: [],
                size: size
            )
        }
    }
    
    @Test
    func oneColorFillsWholeImage() async throws {
        try await snapshot.assertSnapshot(name: "grid-palette-one-color") {
            try renderer.render(
                colors: [
                    [0.2, 0.4, 0.5]
                ],
                size: size
            )
        }
    }
    
    @Test
    func twoColorsStackEquallyInVerticalDirection() async throws {
        try await snapshot.assertSnapshot(name: "grid-palette-two-colors") {
            try renderer.render(
                colors: [
                    [0.1, 0.2, 0.3],
                    [0.3, 0.2, 0.1]
                ],
                size: size
            )
        }
    }
    
    @Test
    func threeColorsStackEquallyInVerticalDirection() async throws {
        try await snapshot.assertSnapshot(name: "grid-palette-three-colors") {
            try renderer.render(
                colors: [
                    [0.1, 0.2, 0.3],
                    [0.3, 0.2, 0.1],
                    [0.5, 0.7, 0.9],
                ],
                size: size
            )
        }
    }
    
    @Test
    func fourColorsDivideInto2x2Grid() async throws {
        try await snapshot.assertSnapshot(name: "grid-palette-four-colors") {
            try renderer.render(
                colors: [
                    [0.1, 0.2, 0.3],
                    [0.9, 0.6, 0.4],
                    [0.3, 0.2, 0.1],
                    [0.5, 0.7, 0.9],
                ],
                size: size
            )
        }
    }
    
    @Test
    func fiveColorsDivideInto2x3GridWitUnevenDistribution() async throws {
        try await snapshot.assertSnapshot(name: "grid-palette-five-colors") {
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
    func sixColorsDivideInto2x3Grid() async throws {
        try await snapshot.assertSnapshot(name: "grid-palette-six-colors") {
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
