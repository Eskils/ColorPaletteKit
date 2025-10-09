//
//  ColorSwatchDecoder.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 05/10/2025.
//

import Foundation

public protocol ColorSwatchDecoder {
    associatedtype ColorSwatchResult
    func decode(from data: Data) throws(ColorSwatchDecoderError) -> ColorSwatchResult
}
