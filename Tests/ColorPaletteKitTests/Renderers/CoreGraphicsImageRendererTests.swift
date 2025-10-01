//
//  CoreGraphicsImageRendererTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

import Testing
import CoreGraphics
@testable import ColorPaletteKit
import TestHelpers
import Foundation

struct CoreGraphicsImageRendererTests {
    let snapshot = TestSnapshotContext(testsDirectory: URL(fileURLWithPath: #filePath + "/../../../").standardizedFileURL)
    
    @Test(
        arguments: [
            CGSize(width: 100, height: 100),
            CGSize(width: 240, height: 360),
            CGSize(width: 16, height: 16),
            CGSize(width: 2, height: 6),
            CGSize(width: 2.5, height: 6.2),
            CGSize(width: 2.3, height: 6.6),
        ]
    )
    func producedImageHasCorrectSize(size: CGSize) throws {
        let expectedWidth = Int(floor(size.width))
        let expectedHeight = Int(floor(size.height))
        let renderer = try CoreGraphicsImageRenderer(size: size)
        
        #expect(renderer.context.width == expectedWidth)
        #expect(renderer.context.height == expectedHeight)
        
        let image = try renderer.image { context in
            context.setFillColor(.black)
            context.addRect(CGRect(origin: .zero, size: size))
            context.drawPath(using: .fill)
        }
        
        #expect(image.width == expectedWidth)
        #expect(image.height == expectedHeight)
    }
    
    @Test
    func producedImageRecreatesColorAndPositionOfRectangles() async throws {
        try await snapshot.assertSnapshot(name: "cg-image-renderer-sample") {
            let size = CGSize(width: 360, height: 100)
            let numberOfShades = 36
            let fNumberOfShades = CGFloat(numberOfShades)
            let rectangleSize = CGSize(width: size.width / fNumberOfShades, height: size.height)
            let renderer = try CoreGraphicsImageRenderer(size: size)
            return try renderer.image { context in
                for i in 0..<numberOfShades {
                    let fI = CGFloat(i)
                    let time = fI / fNumberOfShades
                    let normalizedTime = 2 * .pi * time
                    let red = cos(normalizedTime)
                    let green = cos(normalizedTime + .pi / 2)
                    let blue = cos(normalizedTime + .pi)
                    context.setFillColor(CGColor(red: red, green: green, blue: blue, alpha: 1))
                    context.addRect(CGRect(origin: CGPoint(x: fI * rectangleSize.width, y: 0), size: size))
                    context.drawPath(using: .fill)
                }
            }
        }
    }
}
