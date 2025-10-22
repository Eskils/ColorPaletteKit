//
//  RGBBaseColorSpaceConverterTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 22/10/2025.
//

import Testing
import ColorPaletteKit
import TestHelpers

struct RGBBaseColorSpaceConverterTests {
    let yellow: [Float] = [1, 1, 0]
    let cyan: [Float] = [0, 1, 1]
    let magenta: [Float] = [1, 0, 1]
    let black: [Float] = [0, 0, 0]
    let white: [Float] = [1, 1, 1]
    
    @Test
    func rgbToRgb() throws {
        let converter = ColorSpaceConverter(from: .rgb, to: .rgb)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [1, 1, 0])
        #expect(cyan == [0, 1, 1])
        #expect(magenta == [1, 0, 1])
        #expect(black == [0, 0, 0])
        #expect(white == [1, 1, 1])
    }
    
    
    @Test
    func rgbToCmyk() throws {
        let converter = ColorSpaceConverter(from: .rgb, to: .cmyk)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0.06, 0.01, 0.72, 0])
        #expect(cyan == [0.41, 0, 0.13, 0])
        #expect(magenta == [0.29, 0.55, 0, 0])
        #expect(black == [0.74, 0.71, 0.64, 0.87])
        #expect(white == [0, 0, 0, 0])
    }
    
    @Test
    func rgbToLab() throws {
        let converter = ColorSpaceConverter(from: .rgb, to: .lab)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [96.64, -14.25, 93.8])
        #expect(cyan == [89.77, -51.76, -16.49])
        #expect(magenta == [63.87, 85.52, -54.91])
        #expect(black == [0, 0, 0])
        #expect(white == [100, 0, 0])
    }
    
    @Test
    func rgbToHsb() throws {
        let converter = ColorSpaceConverter(from: .rgb, to: .hsb)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0.17, 1, 1])
        #expect(cyan == [0.5, 1, 1])
        #expect(magenta == [0.83, 1, 1])
        #expect(black == [0, 0, 0])
        #expect(white == [0, 0, 1])
    }
    
    @Test
    func rgbToGray() throws {
        let converter = ColorSpaceConverter(from: .rgb, to: .gray)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0.96])
        #expect(cyan == [0.89])
        #expect(magenta == [0.61])
        #expect(black == [0])
        #expect(white == [1])
    }
}
