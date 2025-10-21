//
//  ColorSpaceConverterTests.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 21/10/2025.
//

import Testing
import ColorPaletteKit

struct ColorSpaceConverterTests {
    @Test
    func rgbBaseConverterThrowsForTooFewComponents() throws {
        let converter = ColorSpaceConverter(from: .rgb, to: .rgb)
        #expect(throws: ColorConverterError.tooFewColorValues(received: 1, expected: 3)) {
            try converter.convert(color: [0])
        }
        
        #expect(throws: ColorConverterError.tooFewColorValues(received: 2, expected: 3)) {
            try converter.convert(color: [0, 0])
        }
        
        #expect(throws: Never.self) {
            try converter.convert(color: [0, 0, 0])
        }
        
        #expect(throws: Never.self) {
            try converter.convert(color: [0, 0, 0, 0, 0])
        }
    }
    
    @Test
    func cmykBaseConverterThrowsForTooFewComponents() throws {
        let converter = ColorSpaceConverter(from: .cmyk, to: .cmyk)
        #expect(throws: ColorConverterError.tooFewColorValues(received: 1, expected: 4)) {
            try converter.convert(color: [0])
        }
        
        #expect(throws: ColorConverterError.tooFewColorValues(received: 2, expected: 4)) {
            try converter.convert(color: [0, 0])
        }
        
        #expect(throws: ColorConverterError.tooFewColorValues(received: 3, expected: 4)) {
            try converter.convert(color: [0, 0, 0])
        }
        
        #expect(throws: Never.self) {
            try converter.convert(color: [0, 0, 0, 0])
        }
        
        #expect(throws: Never.self) {
            try converter.convert(color: [0, 0, 0, 0, 0, 0])
        }
    }
    
    @Test
    func labBaseConverterThrowsForTooFewComponents() throws {
        let converter = ColorSpaceConverter(from: .lab, to: .lab)
        #expect(throws: ColorConverterError.tooFewColorValues(received: 1, expected: 3)) {
            try converter.convert(color: [0])
        }
        
        #expect(throws: ColorConverterError.tooFewColorValues(received: 2, expected: 3)) {
            try converter.convert(color: [0, 0])
        }
        
        #expect(throws: Never.self) {
            try converter.convert(color: [0, 0, 0])
        }
        
        #expect(throws: Never.self) {
            try converter.convert(color: [0, 0, 0, 0, 0])
        }
    }
    
    @Test
    func hsbBaseConverterThrowsForTooFewComponents() throws {
        let converter = ColorSpaceConverter(from: .hsb, to: .hsb)
        #expect(throws: ColorConverterError.tooFewColorValues(received: 1, expected: 3)) {
            try converter.convert(color: [0])
        }
        
        #expect(throws: ColorConverterError.tooFewColorValues(received: 2, expected: 3)) {
            try converter.convert(color: [0, 0])
        }
        
        #expect(throws: Never.self) {
            try converter.convert(color: [0, 0, 0])
        }
        
        #expect(throws: Never.self) {
            try converter.convert(color: [0, 0, 0, 0, 0])
        }
    }
    
    @Test
    func grayBaseConverterThrowsForTooFewComponents() throws {
        let converter = ColorSpaceConverter(from: .gray, to: .gray)
        #expect(throws: ColorConverterError.tooFewColorValues(received: 0, expected: 1)) {
            try converter.convert(color: [])
        }
        
        #expect(throws: Never.self) {
            try converter.convert(color: [0])
        }
        
        #expect(throws: Never.self) {
            try converter.convert(color: [0, 0, 0])
        }
    }
    
    @Test
    func rgbToCmyk() throws {
        let converter = ColorSpaceConverter(from: .rgb, to: .cmyk)
        
        let yellow = try converter.convert(color: [1, 1, 0]).map(roundToTwoDigits)
        let cyan = try converter.convert(color: [0, 1, 1]).map(roundToTwoDigits)
        let magenta = try converter.convert(color: [1, 0, 1]).map(roundToTwoDigits)
        let black = try converter.convert(color: [0, 0, 0]).map(roundToTwoDigits)
        let white = try converter.convert(color: [1, 1, 1]).map(roundToTwoDigits)
        
        #expect(yellow == [0.06, 0.01, 0.72, 0])
        #expect(cyan == [0.41, 0, 0.13, 0])
        #expect(magenta == [0.29, 0.55, 0, 0])
        #expect(black == [0.74, 0.71, 0.64, 0.87])
        #expect(white == [0, 0, 0, 0])
    }
}


private func roundToTwoDigits(_ value: Float) -> Float {
    (value * 100).rounded() / 100
}
