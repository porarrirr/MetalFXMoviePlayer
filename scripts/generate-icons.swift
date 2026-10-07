#!/usr/bin/env swift
import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let source = root.appendingPathComponent("assets/AppIcon-master.png")
guard let image = NSImage(contentsOf: source) else { fatalError("Missing \(source.path)") }
let fm = FileManager.default
func png(size: Int, mac: Bool) -> Data {
    let context = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8,
        bytesPerRow: size * 4, space: CGColorSpace(name: CGColorSpace.sRGB)!,
        bitmapInfo: (mac ? CGImageAlphaInfo.premultipliedLast : CGImageAlphaInfo.noneSkipLast).rawValue)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)
    let bounds = NSRect(x: 0, y: 0, width: size, height: size)
    NSColor.clear.setFill()
    bounds.fill()
    let rect = mac ? bounds.insetBy(dx: CGFloat(size) * 0.08, dy: CGFloat(size) * 0.08) : bounds
    if mac {
        NSBezierPath(roundedRect: rect, xRadius: CGFloat(size) * 0.185,
                     yRadius: CGFloat(size) * 0.185).addClip()
    }
    NSGraphicsContext.current?.imageInterpolation = .high
    image.draw(in: rect, from: .zero, operation: .copy, fraction: 1)
    NSGraphicsContext.restoreGraphicsState()
    return NSBitmapImageRep(cgImage: context.makeImage()!).representation(using: .png, properties: [:])!
}
let ios = root.appendingPathComponent("ios/MovieFXPlayerIOS/Assets.xcassets/AppIcon.appiconset")
let mac = root.appendingPathComponent("macos/AppIcon.iconset")
try fm.createDirectory(at: ios, withIntermediateDirectories: true)
try fm.createDirectory(at: mac, withIntermediateDirectories: true)
var entries: [[String: String]] = []
for (idiom, sizes) in [("iphone", [20.0, 29, 40, 60]), ("ipad", [20.0, 29, 40, 76, 83.5])] {
    for size in sizes {
        let scales = idiom == "iphone" ? [2, 3] : (size == 83.5 ? [2] : [1, 2])
        for scale in scales {
            let label = size == size.rounded() ? String(Int(size)) : String(size)
            let filename = "icon-\(idiom)-\(label)@\(scale)x.png"
            try png(size: Int(size * Double(scale)), mac: false).write(to: ios.appendingPathComponent(filename))
            entries.append(["idiom": idiom, "size": "\(label)x\(label)", "scale": "\(scale)x", "filename": filename])
        }
    }
}
try png(size: 1024, mac: false).write(to: ios.appendingPathComponent("icon-1024.png"))
entries.append(["idiom": "ios-marketing", "size": "1024x1024", "scale": "1x", "filename": "icon-1024.png"])
let contents: [String: Any] = ["images": entries, "info": ["author": "xcode", "version": 1]]
try JSONSerialization.data(withJSONObject: contents, options: [.prettyPrinted, .sortedKeys]).write(to: ios.appendingPathComponent("Contents.json"))
try Data("{\"info\":{\"author\":\"xcode\",\"version\":1}}\n".utf8).write(to: ios.deletingLastPathComponent().appendingPathComponent("Contents.json"))
for size in [16, 32, 128, 256, 512] {
    for scale in [1, 2] {
        let filename = "icon_\(size)x\(size)\(scale == 2 ? "@2x" : "").png"
        try png(size: size * scale, mac: true).write(to: mac.appendingPathComponent(filename))
    }
}
