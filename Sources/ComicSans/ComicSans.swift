import Foundation
import SwiftUI

public struct ComicSans {
    let text: String
    public let view: ComicSansView
    
    public init(
        text: String,
        padding: Int,
        horizontalAlignment: HorizontalAlignmentOption,
        verticalAlignment: VerticalAlignmentOption
    ) {
        self.text = text
        self.view = ComicSansView(
            text: text,
            padding: padding,
            horizontalAlignment: horizontalAlignment,
            verticalAlignment: verticalAlignment,
            debug: false
        )
    }
    
    public func emojiName() -> String {
        let replacements: [(String, String)] = [
            ("...", " ellipsis "),
            ("…", " ellipsis "),
            (".", " full stop "),
            (",", " comma "),
            ("?", " question mark "),
            (":", " colon "),
            ("!", " exclamation mark "),
            (";", " semicolon "),
            ("-", " dash "),
            ("–", " en dash "),
            ("—", " em dash "),
            ("/", " slash "),
            ("\n", " ")
        ]
        
        var temp = text.lowercased()
        for (pattern, replacement) in replacements {
            temp = temp.replacingOccurrences(of: pattern, with: replacement)
        }
        
        var isQuote = true
        temp = temp.reduce(into: "") { result, char in
            if char == "\"" {
                result += isQuote ? " quote " : " unquote "
                isQuote.toggle()
            } else {
                result.append(char)
            }
        }
        
        let result = temp.components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .map { $0.components(separatedBy: CharacterSet.alphanumerics.inverted).joined() }
            .joined(separator: "-")
        
        return result.isEmpty && !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "unknown" : result
    }
    
    @MainActor public func pngRepresentation(scale: Int = 2) -> Data? {
        let renderer = ImageRenderer(content: view)
        renderer.scale = CGFloat(scale)

        return renderer.nsImage?.pngRepresentation
    }
}
