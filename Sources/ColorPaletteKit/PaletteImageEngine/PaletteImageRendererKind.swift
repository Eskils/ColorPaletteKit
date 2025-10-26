//
//  PaletteImageRendererKind.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

/// The possible ways to arrange a palette on a 2D surface.
public enum PaletteImageRendererKind: Sendable {
    /// Arrange the palette in stripes laid out horizontally
    case spectrum
    /// Arrange the palette in a grid.
    case grid(Grid)
}

extension PaletteImageRendererKind {
    /// Arrange the palette in a grid.
    public static let grid = PaletteImageRendererKind.grid(Grid())
}

extension PaletteImageRendererKind {
    /// Options for arranging a palette in a grid.
    public struct Grid: Sendable {
        /// The number of colors to arrange next to each other before starting a new row.
        public var maxColumns: Int
        
        public init(maxColumns: Int = 6) {
            self.maxColumns = maxColumns
        }
    }
}

extension PaletteImageRendererKind {
    func renderer() -> any PaletteImageRenderer {
        switch self {
        case .spectrum:
            SpectrumPaletteImageRenderer()
        case .grid(let grid):
            GridPaletteImageRenderer(maxColumns: grid.maxColumns)
        }
    }
}
