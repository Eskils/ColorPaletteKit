//
//  GridPaletteImageRenderer.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

import CoreGraphics

struct GridPaletteImageRenderer: PaletteImageRenderer {
    let maxColumns: Int
    
    func render(colors: [SIMD3<Float>], size: CGSize) throws(PaletteImageRendererError) -> CGImage {
        do {
            let renderer = try CoreGraphicsImageRenderer(size: size)
            return try renderer.image { cgContext in
                var rows = colors.count == 1 ? 1 : 2 + Int(floor(Double(colors.count) / Double(maxColumns)))
                let columns = colors.count / rows
                let numMissingColors = colors.count - rows * columns
                let hasMissingColors = numMissingColors > 0
                if hasMissingColors {
                    rows += 1
                }
                let columnWidth = size.width / CGFloat(columns)
                let rowHeight = size.height / CGFloat(rows)
                let lastRowWidth = size.width / CGFloat(hasMissingColors ? numMissingColors : columns)
                for (i, color) in colors.enumerated() {
                    let cgColor = CGColor(red: CGFloat(color.x), green: CGFloat(color.y), blue: CGFloat(color.z), alpha: 1)
                    let column = CGFloat(i % columns)
                    let row = CGFloat(rows - 1) - CGFloat(i / columns)
                    let isLastRow = Int(row) == rows - 1
                    let width = (isLastRow ? lastRowWidth : columnWidth)
                    let rect = CGRect(x: column * width, y: row * rowHeight, width: width, height: rowHeight)
                    cgContext.addPath(CGPath(rect: rect, transform: nil))
                    cgContext.setFillColor(cgColor)
                    cgContext.setStrokeColor(cgColor)
                    cgContext.drawPath(using: .fill)
                }
            }
        } catch {
            throw .renderFailure(underlying: error)
        }
    }
}
