//
//  isWithinAcceptedThreshold.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 05/10/2025.
//

import simd

func sort(colors: [SIMD3<Float>]) -> [SIMD3<Float>] {
    colors.sorted {
        $0.x < $1.x
    }
}

public func isWithinAcceptedThreshold(colors: [SIMD3<Float>], expectedColors: [SIMD3<Float>], threshold: Float) -> Bool {
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
