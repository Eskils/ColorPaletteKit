//
//  roundToTwoDigits.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 22/10/2025.
//


public func roundToTwoDigits(_ value: Float) -> Float {
    (value * 100).rounded() / 100
}
