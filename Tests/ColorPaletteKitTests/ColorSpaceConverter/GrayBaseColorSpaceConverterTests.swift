//
//  GrayBaseColorSpaceConverterTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 23/10/2025.
//

import Testing
import ColorPaletteKit
import TestHelpers

struct GrayBaseColorSpaceConverterTests {
    let dark: [Float] = [0.25]
    let gray: [Float] = [0.5]
    let light: [Float] = [0.75]
    let black: [Float] = [0]
    let white: [Float] = [1]
    
    @Test
    func grayToRgb() throws {
        let converter = ColorSpaceConverter(from: .gray, to: .rgb)
        
        let dark = try converter.convert(color: dark).map(roundToTwoDigits)
        let gray = try converter.convert(color: gray).map(roundToTwoDigits)
        let light = try converter.convert(color: light).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(dark == [0.25, 0.25, 0.25])
        #expect(gray == [0.5, 0.5, 0.5])
        #expect(light == [0.75, 0.75, 0.75])
        #expect(black == [0, 0, 0])
        #expect(white == [1, 1, 1])
    }
    
    
    @Test
    func grayToCmyk() throws {
        let converter = ColorSpaceConverter(from: .gray, to: .cmyk)
        
        let dark = try converter.convert(color: dark).map(roundToTwoDigits)
        let gray = try converter.convert(color: gray).map(roundToTwoDigits)
        let light = try converter.convert(color: light).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(dark == [0.73, 0.65, 0.6, 0.16])
        #expect(gray == [0.43, 0.35, 0.32, 0.01])
        #expect(light == [0.18, 0.13, 0.11, 0])
        #expect(black == [0.74, 0.71, 0.64, 0.87])
        #expect(white == [0, 0, 0, 0])
    }
    
    @Test
    func grayToLab() throws {
        let converter = ColorSpaceConverter(from: .gray, to: .lab)
        
        let dark = try converter.convert(color: dark).map(roundToTwoDigits)
        let gray = try converter.convert(color: gray).map(roundToTwoDigits)
        let light = try converter.convert(color: light).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(dark == [34.49, 0, 0])
        #expect(gray == [60.53, 0, 0])
        #expect(light == [81.61, 0, 0])
        #expect(black == [0, 0, 0])
        #expect(white == [100, 0, 0])
    }
    
    @Test
    func grayToHsb() throws {
        let converter = ColorSpaceConverter(from: .gray, to: .hsb)
        
        let dark = try converter.convert(color: dark).map(roundToTwoDigits)
        let gray = try converter.convert(color: gray).map(roundToTwoDigits)
        let light = try converter.convert(color: light).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(dark == [0, 0, 0.25])
        #expect(gray == [0, 0, 0.5])
        #expect(light == [0, 0, 0.75])
        #expect(black == [0, 0, 0])
        #expect(white == [0, 0, 1])
    }
    
    @Test
    func grayToGray() throws {
        let converter = ColorSpaceConverter(from: .gray, to: .gray)
        
        let dark = try converter.convert(color: dark).map(roundToTwoDigits)
        let gray = try converter.convert(color: gray).map(roundToTwoDigits)
        let light = try converter.convert(color: light).map(roundToTwoDigits)
        let black = try converter.convert(color: black).map(roundToTwoDigits)
        let white = try converter.convert(color: white).map(roundToTwoDigits)
        
        #expect(dark == [0.25])
        #expect(gray == [0.5])
        #expect(light == [0.75])
        #expect(black == [0])
        #expect(white == [1])
    }
}
