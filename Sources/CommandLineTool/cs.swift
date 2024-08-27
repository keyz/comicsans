import ArgumentParser
import ComicSans
import Darwin
import SwiftUI

@main
struct cs: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "cs",
        abstract: "cs (comic sans) for :pink-slack-emoji:",
        usage: """
        Pass text as an argument:
        $ cs 'Write something here and get a png back'

        Or pass text through a pipe:
        $ echo -n 'seems legit' | cs
        """,
        discussion: """
        Converts text to pink comic sans slack emoji. https://github.com/keyz/comicsans
        """,
        version: "0.2.0",
        helpNames: .long
    )

    @Argument(help: "Text to convert")
    var text: String? = nil // NOTE: see `validate()` below

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

        if text == nil, !isBeingPiped {
            throw ValidationError("No text received. You can pass text as an argument or through a pipe.")
        }

        if text != nil, isBeingPiped {
            throw ValidationError("You can pass text either as an argument or through a pipe, but not both.")
        }
    }

    @MainActor mutating func run() throws {
        let text = try text ?? parsePipeInput() // `validate()` ensures there's an active pipe when `text` is `nil`

        let result = ComicSans(
            text,
            padding: padding,
            horizontalAlignment: horizontal,
            verticalAlignment: vertical
        )

        let targetPath = uniqueFilePath(
            basename: result.emojiName() ?? "unknown",
            fileExtension: "png",
            baseDirectory: .currentDirectory()
        )

        guard let pngData = result.pngRepresentation() else {
            throw ExitCode.failure
        }

        try pngData.write(to: targetPath, options: .atomic)
        print("File generated: ./\(targetPath.lastPathComponent)")
    }

    private func uniqueFilePath(basename: String, fileExtension: String, baseDirectory: URL) -> URL {
        var attempt = 0
        var candidate = baseDirectory.appendingPathComponent("\(basename).\(fileExtension)")

        while FileManager.default.fileExists(atPath: candidate.path) {
            attempt += 1
            candidate = baseDirectory.appendingPathComponent("\(basename) (\(attempt)).\(fileExtension)")
        }

        return candidate
    }

    private lazy var isBeingPiped: Bool = isatty(fileno(stdin)) == 0

    private mutating func parsePipeInput() throws -> String {
        assert(isBeingPiped, "No active pipe found")

        guard let data = try? FileHandle.standardInput.readToEnd(),
              let pipeInput = String(data: data, encoding: .utf8)
        else {
            throw ValidationError("No text received. You can pass text as an argument or through a pipe.")
        }

        return pipeInput
    }
}

extension HorizontalAlignmentOption: ExpressibleByArgument {}

extension VerticalAlignmentOption: ExpressibleByArgument {}
