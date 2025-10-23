//
//  LABBaseColorSpaceConverterTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 23/10/2025.
//

import Testing
import ColorPaletteKit
import TestHelpers

struct LABBaseColorSpaceConverterTests {
    let yellow: [Float] = [97, -14.25, 93.8]
    let cyan: [Float] = [90, -51.76, -16.49]
    let magenta: [Float] = [64, 85.52, -54.91]
    let black: [Float] = [0, 0, 0]
    let white: [Float] = [100, 0, 0]
    
    @Test
    func labToRgb() throws {
        let converter = ColorSpaceConverter(from: .lab, to: .rgb)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [1, 0.99, 0])
        #expect(cyan == [0, 0.99, 1])
        #expect(magenta == [1, 0.25, 1])
        #expect(black == [0, 0, 0])
        #expect(white == [1, 1, 1])
    }
    
    
    @Test
    func labToCmyk() throws {
        let converter = ColorSpaceConverter(from: .lab, to: .cmyk)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0.06, 0.01, 0.71, 0])
        #expect(cyan == [0.41, 0, 0.13, 0])
        #expect(magenta == [0.29, 0.55, 0, 0])
        #expect(black == [0.74, 0.71, 0.64, 0.87])
        #expect(white == [0, 0, 0, 0])
    }
    
    @Test
    func labToLab() throws {
        let converter = ColorSpaceConverter(from: .lab, to: .lab)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [97, -14.25, 93.8])
        #expect(cyan == [90, -51.76, -16.49])
        #expect(magenta == [64, 85.52, -54.91])
        #expect(black == [0, 0, 0])
        #expect(white == [100, 0, 0])
    }
    
    @Test
    func labToHsb() throws {
        let converter = ColorSpaceConverter(from: .lab, to: .hsb)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0.16, 1, 1])
        #expect(cyan == [0.5, 1, 1])
        #expect(magenta == [0.83, 0.75, 1])
        #expect(black == [0.52, 1.0, 0])
        #expect(white == [0, 0, 1])
    }
    
    @Test
    func labToGray() throws {
        let converter = ColorSpaceConverter(from: .lab, to: .gray)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0.97])
        #expect(cyan == [0.89])
        #expect(magenta == [0.61])
        #expect(black == [0])
        #expect(white == [1])
    }
}
