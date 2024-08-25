import AppKit

extension NSImage {
    var pngRepresentation: Data? {
        guard let tiffData = tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData)
        else {
            return nil
        }

        return bitmapRep.representation(using: .png, properties: [:])
    }
}
