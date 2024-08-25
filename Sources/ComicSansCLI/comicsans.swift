import ArgumentParser
import ComicSans
import SwiftUI

@main
struct comicsans: ParsableCommand {
    @Option(name: [.short, .long], help: "Padding (values: 0, 4, 8, 12, 16, 20, 24)")
    var padding: Int = 4

    @Option(name: [.short, .long], help: "Horizontal alignment")
    var horizontal: HorizontalAlignmentOption = .leading

    @Option(name: [.short, .long], help: "Vertical alignment")
    var vertical: VerticalAlignmentOption = .center

    mutating func validate() throws {
        guard [0, 4, 8, 12, 16, 20, 24].contains(padding) else {
            throw ValidationError("Padding must be a multiple of 4; valid range is 0 to 24.")
        }
    }

    @MainActor mutating func run() throws {
        print("Padding: \(padding), horizontal: \(horizontal), vertical: \(vertical)")

        let resultView = ComicSansView(
            text: "TODO",
            padding: padding,
            horizontalAlignment: horizontal,
            verticalAlignment: vertical,
            debug: false
        )

        let renderer = ImageRenderer(content: resultView)
        renderer.scale = 2.0 // TODO: should this be higher?

        let targetPath = URL(filePath: "TODO.png", directoryHint: .inferFromPath, relativeTo: .currentDirectory())

        if let pngData = renderer.nsImage?.pngRepresentation {
            try pngData.write(to: targetPath, options: .atomic)
        }
    }
}

extension HorizontalAlignmentOption: ExpressibleByArgument {}

extension VerticalAlignmentOption: ExpressibleByArgument {}
