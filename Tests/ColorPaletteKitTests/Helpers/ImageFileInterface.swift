//
//  ImageFileInterface.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 06/06/2025.
//

import Foundation
import CoreGraphics
import ImageIO

struct ImageFileInterface {
    private init() {}
    
    static func image(atPath path: String) throws(ImageFileInterfaceError) -> CGImage {
        let url = URL(fileURLWithPath: path)
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw .cannotReadContentsOfFile(url, error)
        }
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
            throw .cannotMakeImageSource
        }
        guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            throw .cannotMakeCGImageFromData
        }
        
        return cgImage
    }

    static func write(image: CGImage, toPath path: String) throws(ImageFileInterfaceError) {
        let data = NSMutableData()
        guard
            let imageDestination = CGImageDestinationCreateWithData(data as CFMutableData, "public.png" as CFString, 1, nil)
        else {
            throw .cannotMakeImageDestination
        }
        
        CGImageDestinationAddImage(imageDestination, image, nil)
        CGImageDestinationFinalize(imageDestination)
        
        let directoryPath = URL(fileURLWithPath: path).deletingLastPathComponent().path()
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true)
            } catch {
                throw .cannotMakeDirectory(directoryPath, error)
            }
        }
        data.write(toFile: path, atomically: true)
    }
}

enum ImageFileInterfaceError: Error {
    case cannotReadContentsOfFile(URL, Error)
    case cannotMakeDirectory(String, Error)
    case cannotMakeImageSource
    case cannotMakeCGImageFromData
    case cannotMakeImageDestination
}
