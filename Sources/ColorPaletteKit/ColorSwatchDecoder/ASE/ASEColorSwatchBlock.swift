//
//  ASEColorSwatchBlock.swift
//  ColorPaletteKit
//
//  Created by Eskil Gjerde Sviggum on 09/10/2025.
//


public enum ASEColorSwatchBlock: Equatable {
    case group(Group)
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
    
    public struct Group: Equatable {
        public let name: String
        public let components: [ASEColorSwatchBlock]
        
        public init(name: String, components: [ASEColorSwatchBlock]) {
            self.name = name
            self.components = components
        }
    }
    
    public struct ColorEntry: Equatable {
        public let name: String
        public let colorModel: ColorModel
        public let colorType: ColorType
        public let components: [Float]
        
        public init(name: String, colorModel: ColorModel, colorType: ColorType, components: [Float]) {
            self.name = name
            self.colorModel = colorModel
            self.colorType = colorType
            self.components = components
        }
    }
    
    public enum ColorModel: Equatable {
        case rgb
        case cmyk
        case lab
        case gray
    }
    
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
