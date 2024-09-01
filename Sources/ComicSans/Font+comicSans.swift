import SwiftUI

extension Font {
    static func comicSans(size: CGFloat) -> Font {
        let baseFontDescriptor = NSFontDescriptor(name: "Comic Sans MS", size: size)

        let withCascading = baseFontDescriptor.addingAttributes([
            .cascadeList: [
                NSFontDescriptor(name: "Yuanti TC", size: size),
                NSFontDescriptor(name: "Yuanti SC", size: size),
            ],
        ])

        return Font(.init(withCascading, size: size))
    }
}
