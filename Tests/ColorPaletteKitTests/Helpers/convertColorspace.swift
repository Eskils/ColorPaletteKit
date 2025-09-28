//
//  convertColorspace.swift
//  SpriteSheetEngine
//
//  Created by Eskil Gjerde Sviggum on 06/06/2025.
//

import CoreGraphics

func convertColorspace(ofImage image: CGImage, toColorSpace colorSpace: CGColorSpace) -> CGImage? {
    let rect = CGRect(origin: .zero, size: CGSize(width: image.width, height: image.height))
    let context = CGContext(data: nil, width: Int(rect.width), height: Int(rect.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    context.draw(image, in: rect)
    let image = context.makeImage()
    return image
}
