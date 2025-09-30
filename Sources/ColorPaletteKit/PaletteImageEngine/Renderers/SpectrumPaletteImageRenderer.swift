//
//  SpectrumPaletteImageRenderer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

import CoreGraphics

struct SpectrumPaletteImageRenderer: PaletteImageRenderer {
    func render(colors: [SIMD3<Float>], size: CGSize) throws(PaletteImageRendererError) -> CGImage {
        do {
            let renderer = try CoreGraphicsImageRenderer(size: size)
            return try renderer.image { cgContext in
                let colorWidth = size.width / Double(colors.count)
                for (i, color) in colors.enumerated() {
                    let cgColor = CGColor(red: CGFloat(color.x), green: CGFloat(color.y), blue: CGFloat(color.z), alpha: 1)
                    let rect = CGRect(x: CGFloat(i) * colorWidth, y: 0, width: colorWidth, height: size.height)
                    cgContext.addPath(CGPath(rect: rect, transform: nil))
                    cgContext.setFillColor(cgColor)
                    cgContext.setStrokeColor(cgColor)
                    cgContext.drawPath(using: .fillStroke)
                }
            }
        } catch {
            throw .renderFailure(underlying: error)
        }
    }
}
