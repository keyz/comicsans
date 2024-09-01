import Foundation
import SwiftUI

public struct ComicSans {
    let text: String
    public let view: ComicSansView

    public init(
        _ text: String,
        padding: Int = 4,
        horizontalAlignment: HorizontalAlignmentOption = .leading,
        verticalAlignment: VerticalAlignmentOption = .center
    ) {
        self.text = text
        view = ComicSansView(
            text: text,
            padding: padding,
            horizontalAlignment: horizontalAlignment,
            verticalAlignment: verticalAlignment
        )
    }

    public func emojiName() -> String? {
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
            ("\\", " backslash "),
            ("$", " dollar sign "),
            ("@", " at "),
            ("&", " and "),
            ("#", " hashtag "),
            ("(", " parenthesis "),
            (")", " parenthesis "),
            ("\n", " "),
        ]

        var temp = text.lowercased()
        for (pattern, replacement) in replacements {
            temp = temp.replacingOccurrences(of: pattern, with: replacement)
        }

        var isOpeningQuote = true
        temp = temp.reduce(into: "") { result, char in
            if char == "\"" {
                result += isOpeningQuote ? " quote " : " unquote "
                isOpeningQuote.toggle()
            } else {
                result.append(char)
            }
        }

        let result = temp.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .map { $0.components(separatedBy: CharacterSet.alphanumerics.inverted).joined() }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "-")

        return result.isEmpty ? nil : result
    }

    @MainActor public func pngRepresentation(scale: Int = 2) -> Data? {
        let renderer = ImageRenderer(content: view)
        renderer.scale = CGFloat(scale)

        return renderer.nsImage?.pngRepresentation
    }
}
