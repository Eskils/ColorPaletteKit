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
}
