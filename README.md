# Color Palette Kit

Library for iOS and macOS to work with color palettes and swatches.

## Table of contents

- [Installation](#installation)
- [Features](#features)
- [Usage](#usage)
   - [Render a palette to an image](#render-a-palette-to-an-image)
   - [Compute the dominant colors in an image](#compute-the-dominant-colors-in-an-image)
   - [Encode a palette to be read by other programs](#encode-a-palette-to-be-read-by-other-programs)
   - [Decode a palette from another program](#decode-a-palette-from-another-program)
   - [Convert a color between color spaces](#convert-a-color-between-color-spaces)
- [Roadmap](#roadmap)
- [Contributing](#contributing)

## Features

Listed are the core problems this library aims to solve:

- [PaletteImageEngine](#render-a-palette-to-an-image) — Render a palette to an image
- [ImagePaletteEngine](#compute-the-dominant-colors-in-an-image) — Compute the dominant colors in an image
- [ColorSwatchEncoder](#encode-a-palette-to-be-read-by-other-programs) — Encode a palette to be read by other programs
- [ColorSwatchDecoder](#decode-a-palette-from-another-program) — Decode a palette from another program
- [ColorSpaceConverter](#convert-a-color-between-color-spaces) — Convert a color between color spaces

## Installation

To use this package in a SwiftPM project, you need to set it up as a package dependency:

```swift
// swift-tools-version:6.1
import PackageDescription

let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(
      url: "https://github.com/Eskils/ColorPaletteKit", 
      .upToNextMinor(from: "0.1.0") // or `.upToNextMajor
    )
  ],
  targets: [
    .target(
      name: "MyTarget",
      dependencies: [
        .product(name: "ColorPaletteKit", package: "ColorPaletteKit")
      ]
    )
  ]
)
```

## Usage

ColorPaletteKit covers many usecases related to color palettes. Please see the section that describes your topic.

In most cases a RGB color is represented by a `SIMD3<Float>` type. Thus a color palette can be expressed as an array of simd floats: `[SIMD3<Float>]`. A single precision float is sufficient to store a single color component between 0.0 and 1.0, grouping three together in a simd type makes computation efficient.

Alpha components are largely neglected from this library. For some usecases this is unfortunate, in other usecases the alpha component would simply be passed through, and is something you can implement in your program. Each section describes how alpha is handled. Improved support for alpha is on the feature roadmap.

### Render a palette to an image

Use `PaletteImageEngine` to render a palette to an image. PaletteImageEngine is constructed with an arrangement kind and can then generate images given a list of colors in the RGB color space.

Alpha is not supported.

> **TIP:** If your palette has colors in a color space different from RGB, you can use `ColorSpaceConverter` to convert.

**Example**

```swift
let palette: [SIMD3<Float>] = [...]
let size = CGSize(width: 100, height: 100)
let paletteImageEngine = PaletteImageEngine(kind: .grid)
let image = try paletteImageEngine.render(colors: palette, size: size)
```

Listed are the supported arrangement kinds:

| Name | Options | Example | Preview |
| ---- | ------- | ------- | ------- |
|`spectrum`| N/A | `PaletteImageEngine(kind: .spectrum)` | ![Spectrum palette image](Resources/spectrum-palette.png) |
|`grid`| [Options](#grid-options) | `PaletteImageEngine(kind: .grid)` | ![Spectrum palette image](Resources/grid-palette.png) |

#### Grid Options

You can configure the grid arrangement with the model `PaletteImageRendererKind.Grid`. Below are the properties you can customize:

| Name | Type | Default |
| ---- | ---- | ------- |
| `maxColumns` | Int | 6 |


### Compute the dominant colors in an image

Use `ImagePaletteEngine` to compute the dominant colors in an image. ImagePaletteEngine is constructed with an image and a computation method. Once constructed you can ask for as many dominant colors as you would like.

Alpha is ignored, but support is on the feature roadmap.

**Example**

```swift
let image: CGImage = ...
let paletteImageEngine = try ImagePaletteEngine(
    cgImage: CGImage,
    method: .equallySpacedSamples
)
let palette = paletteImageEngine.dominantColors(amount: 64)
```

Listed are the supported computation methods:

| Name | Options | Description |
| ---- | ------- | ------- |
|`kMeans`| [Options](#kmeans-options) | More accurate, slower |
|`equallySpacedSamples`| N/A | Less accurate, faster |

#### kMeans Options

You can configure the kMeans computation method using the model `ImagePaletteComputationMethod.KMeans`. Below are the properties you can customize:

| Name | Type | Default | Description |
| ---- | ---- | ------- | ----------- |
| `maximumIterations` | Int | 50 | The maximum iterations until computation gives a result. |
| `tolerance` | Int | 10 | Accepted error in the result |

### Encode a palette to be read by other programs

Use some `ColorSwatchEncoder` to encode a list of colors to a swatch file. Support for alpha depends on the format. Listed are supported swatch formats:

| Format | ColorSwatchInput | Encoder |
| ---- | ---------------- | ------- |
| Adobe Swatch Exchange (ASE) | `[ASEColorSwatchBlock]` | [ASEColorSwatchEncoder](#asecolorswatchencoder) |

#### ASEColorSwatchEncoder

Use `ASEColorSwatchEncoder` to encode a list of colors to the Adobe Swatch Exchange (ASE) format.

Alpha is not supported in ASE.

**Example**

```swift
let swatch: [ASEColorSwatchBlock] = ...
let encoder = ASEColorSwatchEncoder()
let data = try encoder.encode(swatch)
```

### Decode a palette from another program

Use some `ColorSwatchDecoder` to decode a swatch file to its constituent components or a list of colors. Support for alpha depends on the format. Listed are supported swatch formats:

| Format | ColorSwatchInput | Decoder |
| ---- | ---------------- | ------- |
| Adobe Swatch Exchange (ASE) | `[ASEColorSwatchBlock]` | [ASEColorSwatchDecoder](#asecolorswatchdecoder) |

#### ASEColorSwatchDecoder

Use `ASEColorSwatchDecoder` to decode an Adobe Swatch Exchange (ASE) file to its constituent components.

Alpha is not supported in ASE.

**Examples**

```swift
let data: Data = ...
let decoder = ASEColorSwatchDecoder()
let blocks = try decoder.decode(from: data)

for block in blocks {
    switch block {
    case .group(let group):
        ...
    case .colorEntry(let color):
        ...
    }
}
```

You can also decode into a list of RGB colors using `decodeColors(from:)`:

```swift
let data: Data = ...
let decoder = ASEColorSwatchDecoder()
let palette: [SIMD3<Float>] = try decoder.decodeColors(from: data)
```

`decodeColors(from:)` will call the base `decode(from:)` and then extract only the colors and convert them to RGB.

### Convert a color between color spaces

Use `ColorSpaceConverter` to convert a color between color spaces/models. ColorSpaceConverter is constructed with a base and target color space and can then convert a color as an array of floats.

Alpha is ignored, but support is on the feature roadmap. You can simply copy the alpha value from the base to the target.

Listed are supported color spaces/models:

- RGB
- CMYK
- LAB
- HSB
- Gray

A conversion is considered lossy when converting to a color space and back does not give the same color as the original. The below table illustrates which conversions are lossy:

| ---- | RGB | CMYK | LAB | HSB | Gray |
| ---- | --- | ---- | --- | --- | ---- |
| RGB  |     | X    | X   |     | X    |
| CMYK | X   |      | X   | X   | X    |
| LAB  | X   | X    |     | X   | X    |
| HSB  |     | X    | X   |     | X    |
| Gray | X   | X    | X   | X   |      |

## Roadmap

This library is used in [Ditherable](https://www.e-skils.com/projects/ditherable/) and is therefore actively maintained. New features in this library will mainly revolve around Ditherable, but suggestions are always welcome!

Listed are planned features:

- Support for encoding and decoding more formats.
- Support for converting between YCbCr, HSV, CIEXYZ, and HCL
- Support for averaged equally spaced samples in ImagePaletteEngine
- Support for sorting colors when rendering to an image
- Support for lenient decoding of swatch formats
- Support for alpha
- Attempt to make more color conversions lossless

## Contributing

Contributions are welcome and encouraged. Feel free to check out the project, submit issues and code patches.

Your feedback is of great value. Open an issue and let me know if you encounter any difficulties or what features you are missing.