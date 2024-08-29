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
        $ echo -n 'seems legit' | cs -
        """,
        discussion: """
        Converts text to pink comic sans slack emoji. https://github.com/keyz/comicsans
        """,
        version: "0.3.0",
        helpNames: .long
    )

    @Argument(help: "Text to convert")
    var text: String

    @Option(name: [.short, .long], help: "Padding (values: 0, 4, 8, 12, 16, 20, 24)")
    var padding: Int = 4

    @Option(name: [.short, .long], help: "Horizontal alignment")
    var horizontal: HorizontalAlignmentOption = .leading

    @Option(name: [.short, .long], help: "Vertical alignment")
    var vertical: VerticalAlignmentOption = .center

    @Option(name: [.short, .long], help: "Output directory", transform: URL.init(fileURLWithPath:))
    var output: URL = .currentDirectory()

    private lazy var isBeingPiped: Bool = isatty(fileno(stdin)) == 0
    private lazy var isExpectingPipe: Bool = text == "-" && CommandLine.arguments.last == "-"

    mutating func validate() throws {
        guard [0, 4, 8, 12, 16, 20, 24].contains(padding) else {
            throw ValidationError("Padding must be a multiple of 4; valid range is 0 to 24.")
        }

        if isExpectingPipe, !isBeingPiped {
            throw ValidationError("No text received. You can pass text as an argument or through a pipe.")
        }

        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: output.path, isDirectory: &isDirectory) {
            guard isDirectory.boolValue else {
                throw ValidationError("Output path already exists and is a file path.")
            }
        }
    }

    @MainActor mutating func run() throws {
        let text = try isExpectingPipe ? parsePipeInput() : text

        let result = ComicSans(
            text,
            padding: padding,
            horizontalAlignment: horizontal,
            verticalAlignment: vertical
        )

        let targetPath = try uniqueFilePath(
            basename: result.emojiName() ?? "unknown",
            fileExtension: "png"
        )

        guard let pngData = result.pngRepresentation() else {
            throw ExitCode.failure
        }

        let displayPath = (output == .currentDirectory()) ?
            "./\(targetPath.lastPathComponent)" :
            targetPath.path

        try pngData.write(to: targetPath, options: .atomic)
        print("File generated: \(displayPath)")
    }
}

extension cs {
    private mutating func parsePipeInput() throws -> String {
        assert(isExpectingPipe, "Not expecting pipe")
        assert(isBeingPiped, "No active pipe found")

        guard let data = try? FileHandle.standardInput.readToEnd(),
              let pipeInput = String(data: data, encoding: .utf8)
        else {
            throw ValidationError("No text received. You can pass text as an argument or through a pipe.")
        }

        return pipeInput
    }

    private func uniqueFilePath(basename: String, fileExtension: String) throws -> URL {
        try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)

        var attempt = 0
        var candidate = output.appendingPathComponent("\(basename).\(fileExtension)")

        while FileManager.default.fileExists(atPath: candidate.path) {
            attempt += 1
            candidate = output.appendingPathComponent("\(basename) (\(attempt)).\(fileExtension)")
        }

        return candidate
    }
}

extension HorizontalAlignmentOption: ExpressibleByArgument {}

extension VerticalAlignmentOption: ExpressibleByArgument {}
