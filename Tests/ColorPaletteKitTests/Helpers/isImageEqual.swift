//
//  isImageEqual.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 06/06/2025.
//

import CoreGraphics

func isImageEqual(original imagePath: String, transformed producedOutputPath: String, expected expectedImagePath: String, afterPerformingImageOperations block: (CGImage) throws -> CGImage) throws -> Bool {
    let inputImage = try ImageFileInterface.image(atPath: imagePath)
    let processedImage = try block(inputImage)
    
    try ImageFileInterface.write(image: processedImage, toPath: producedOutputPath)
    
    let expectedImage = try ImageFileInterface.image(atPath: expectedImagePath)
    
    return try isImageEqual(actual: processedImage, expected: expectedImage)
}

func isImageEqual(actual: CGImage, transformed producedOutputPath: String? = nil, expected expectedImagePath: String) throws -> Bool {
    if let producedOutputPath {
        try ImageFileInterface.write(image: actual, toPath: producedOutputPath)
    }
    let expectedImage = try ImageFileInterface.image(atPath: expectedImagePath)
    return try isImageEqual(actual: actual, expected: expectedImage)
}

func isImageEqual(actual: CGImage, expected: CGImage) throws -> Bool {
    let colorspace = CGColorSpaceCreateDeviceRGB()
    let convertedProcessed = convertColorspace(ofImage: actual, toColorSpace: colorspace)
    let convertedExpected = convertColorspace(ofImage: expected, toColorSpace: colorspace)
    
    let isEqual = convertedProcessed?.dataProvider?.data == convertedExpected?.dataProvider?.data
    
    if !isEqual {
        print("Image \(String(describing: convertedProcessed)) does not match expected \(String(describing: convertedExpected))")
    }
    
    return isEqual
}
