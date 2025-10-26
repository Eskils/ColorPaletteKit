//
//  ASEColorSwatchBlock.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 09/10/2025.
//


/// A block in the ASE format
public enum ASEColorSwatchBlock: Equatable {
    /// A group of colors
    case group(Group)
    /// A single color
    case colorEntry(ColorEntry)
}

extension ASEColorSwatchBlock {
    enum Kind {
        case group
        case colorEntry
    }
    
    enum ExtensiveKind {
        case groupStart
        case groupEnd
        case colorEntry
    }
    
    /// A group of colors
    public struct Group: Equatable {
        /// The name of the group
        public let name: String
        /// The components in the group.
        /// This could be colors, groups or a mix of both.
        public let components: [ASEColorSwatchBlock]
        
        public init(name: String, components: [ASEColorSwatchBlock]) {
            self.name = name
            self.components = components
        }
    }
    
    /// A single color
    public struct ColorEntry: Equatable {
        /// The name of the color
        /// This is often an empty string.
        public let name: String
        /// The color space of the color
        public let colorModel: ColorModel
        /// The type of color
        public let colorType: ColorType
        /// The values of the color.
        /// The number of entries depends on ``colorModel``
        public let components: [Float]
        
        public init(name: String, colorModel: ColorModel, colorType: ColorType, components: [Float]) {
            self.name = name
            self.colorModel = colorModel
            self.colorType = colorType
            self.components = components
        }
    }
    
    /// The color space of the color
    public enum ColorModel: Equatable {
        case rgb
        case cmyk
        case lab
        case gray
    }
    
    /// The type of color
    public enum ColorType: Equatable {
        case global
        case spot
        case normal
    }
}

extension ASEColorSwatchBlock {
    var kind: Kind {
        switch self {
        case .group:
                .group
        case .colorEntry:
                .colorEntry
        }
    }
    
    var numberOfBlocks: Int {
        switch self {
        case .group(let group):
            2 + group.components.reduce(0) { partialResult, block in
                partialResult + block.numberOfBlocks
            }
        case .colorEntry:
            1
        }
    }
    
    var colorEntries: [ColorEntry] {
        switch self {
        case .colorEntry(let colorEntry):
            [colorEntry]
        case .group(let group):
            group.components.flatMap { $0.colorEntries }
        }
    }
}

extension ASEColorSwatchBlock.ExtensiveKind {
    init?(identifier: UInt16) {
        switch identifier {
        case 0xc001: self = .groupStart
        case 0xc002: self = .groupEnd
        case 0x01: self = .colorEntry
        default: return nil
        }
    }
    
    var identifier: UInt16 {
        switch self {
        case .groupStart: 0xc001
        case .groupEnd: 0xc002
        case .colorEntry: 0x01
        }
    }
}

extension ASEColorSwatchBlock.ColorModel {
    init?(identifier: String) {
        switch identifier {
        case "RGB ": self = .rgb
        case "CMYK": self = .cmyk
        case "LAB ": self = .lab
        case "GRAY": self = .gray
        default: return nil
        }
    }
    
    var identifier: String {
        switch self {
        case .rgb: "RGB "
        case .cmyk: "CMYK"
        case .lab: "LAB "
        case .gray: "GRAY"
        }
    }
    
    var numberOfComponents: Int {
        switch self {
        case .rgb:
            3
        case .cmyk:
            4
        case .lab:
            3
        case .gray:
            1
        }
    }
    
    var colorSpaceKind: ColorSpaceKind {
        switch self {
        case .rgb:
            .rgb
        case .cmyk:
            .cmyk
        case .lab:
            .lab
        case .gray:
            .gray
        }
    }
}

extension ASEColorSwatchBlock.ColorType {
    init?(identifier: UInt16) {
        switch identifier {
        case 0x0: self = .global
        case 0x1: self = .spot
        case 0x2: self = .normal
        default: return nil
        }
    }
    
    var identifier: UInt16 {
        switch self {
        case .global: 0x0
        case .spot: 0x1
        case .normal: 0x2
        }
    }
}
