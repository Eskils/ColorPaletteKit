//
//  HSBBaseColorSpaceConverterTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 23/10/2025.
//

import Testing
import ColorPaletteKit
import TestHelpers

struct HSBBaseColorSpaceConverterTests {
    let yellow: [Float] = [0.17, 1, 1]
    let cyan: [Float] = [0.5, 1, 1]
    let magenta: [Float] = [0.83, 1, 1]
    let black: [Float] = [0, 0, 0]
    let white: [Float] = [0, 0, 1]
    
    @Test
    func hsbToRgb() throws {
        let converter = ColorSpaceConverter(from: .hsb, to: .rgb)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0.98, 1, 0])
        #expect(cyan == [0, 1, 1])
        #expect(magenta == [0.98, 0, 1])
        #expect(black == [0, 0, 0])
        #expect(white == [1, 1, 1])
    }
    
    
    @Test
    func hsbToCmyk() throws {
        let converter = ColorSpaceConverter(from: .hsb, to: .cmyk)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0.07, 0, 0.73, 0])
        #expect(cyan == [0.41, 0, 0.13, 0])
        #expect(magenta == [0.3, 0.55, 0, 0])
        #expect(black == [0.74, 0.71, 0.64, 0.87])
        #expect(white == [0, 0, 0, 0])
    }
    
    @Test
    func hsbToLab() throws {
        let converter = ColorSpaceConverter(from: .hsb, to: .lab)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [96.28, -15.9, 93.36])
        #expect(cyan == [89.77, -51.76, -16.49])
        #expect(magenta == [63.15, 84.75, -56.09])
        #expect(black == [0, 0, 0])
        #expect(white == [100, 0, 0])
    }
    
    @Test
    func hsbToHsb() throws {
        let converter = ColorSpaceConverter(from: .hsb, to: .hsb)
        
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
    func hsbToGray() throws {
        let converter = ColorSpaceConverter(from: .hsb, to: .gray)
        
        let yellow = try converter.convert(color: yellow).map(roundToTwoDigits)
        let cyan = try converter.convert(color: cyan).map(roundToTwoDigits)
        let magenta = try converter.convert(color: magenta).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(yellow == [0.96])
        #expect(cyan == [0.89])
        #expect(magenta == [0.6])
        #expect(black == [0])
        #expect(white == [1])
    }
}
