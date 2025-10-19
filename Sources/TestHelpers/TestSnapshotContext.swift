//
//  TestSnapshotContext.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 01/10/2025.
//

import Testing
import CoreGraphics
import Foundation

public struct TestSnapshotContext {
    let testsDirectory: URL
    
    @available(macOS 13.0, iOS 16.0, *)
    private func filePath(name: String, directory: String) -> String {
        "\(testsDirectory.path())/\(directory)/\(name)"
    }
    
    public init(testsDirectory: URL) {
        self.testsDirectory = testsDirectory
    }
    
    @available(macOS 13.0, iOS 16.0, *)
    public func assertSnapshot(name: String, for operations: () async throws -> CGImage) async throws {
        let image = try await operations()
        let fileName = name.lowercased().replacingOccurrences(of: " ", with: "-")
        #expect(
            try isImageEqual(
                actual: image,
                transformed: filePath(name: "\(fileName).png", directory: "ProducedOutputs"),
                expected: filePath(name: "\(fileName).png", directory: "ExpectedOutputs")
            )
        )
    }
}
