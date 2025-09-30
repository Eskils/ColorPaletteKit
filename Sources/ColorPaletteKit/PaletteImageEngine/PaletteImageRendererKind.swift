//
//  PaletteImageRendererKind.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 30/09/2025.
//

public enum PaletteImageRendererKind: Sendable {
    case spectrum
    case grid(Grid)
}

extension PaletteImageRendererKind {
    static let grid = PaletteImageRendererKind.grid(Grid())
}

extension PaletteImageRendererKind {
    public struct Grid: Sendable {
        var maxColumns: Int
        
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
