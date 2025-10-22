//
//  CMYKBaseColorSpaceConverterTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 22/10/2025.
//

import Testing
import ColorPaletteKit
import TestHelpers

struct CMYKBaseColorSpaceConverterTests {
    let yellow: [Float] = [0, 0, 1, 0]
    let cyan: [Float] = [1, 0, 0, 0]
    let magenta: [Float] = [0, 1, 0, 0]
    let black: [Float] = [0, 0, 0, 1]
    let white: [Float] = [0, 0, 0, 0]
    
    @Test
    func cmykToRgb() throws {
        let converter = ColorSpaceConverter(from: .cmyk, to: .rgb)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [1, 0.94, 0.01])
        #expect(cyan == [0, 0.64, 0.86])
        #expect(magenta == [0.85, 0.07, 0.49])
        #expect(black == [0.1, 0.1, 0.1])
        #expect(white == [1, 1, 1])
    }
    
    
    @Test
    func cmykToCmyk() throws {
        let converter = ColorSpaceConverter(from: .cmyk, to: .cmyk)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0, 0, 1, 0])
        #expect(cyan == [1, 0, 0, 0])
        #expect(magenta == [0, 1, 0, 0])
        #expect(black == [0, 0, 0, 1])
        #expect(white == [0, 0, 0, 0])
    }
    
    @Test
    func cmykToLab() throws {
        let converter = ColorSpaceConverter(from: .cmyk, to: .lab)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [94.51, -6.53, 91.86])
        #expect(cyan == [59.22, -40.66, -43.67])
        #expect(magenta == [48.24, 73.79, -4.52])
        #expect(black == [9.02, 0.5, 0.5])
        #expect(white == [100, 0.5, 0.5])
    }
    
    @Test
    func cmykToHsb() throws {
        let converter = ColorSpaceConverter(from: .cmyk, to: .hsb)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0.16, 0.99, 1])
        #expect(cyan == [0.54, 1, 0.86])
        #expect(magenta == [0.91, 0.92, 0.85])
        #expect(black == [0.04, 0.06, 0.1])
        #expect(white == [0.11, 0, 1])
    }
    
    @Test
    func cmykToGray() throws {
        let converter = ColorSpaceConverter(from: .cmyk, to: .gray)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0.94])
        #expect(cyan == [0.56])
        #expect(magenta == [0.45])
        #expect(black == [0.1])
        #expect(white == [1])
    }
}
