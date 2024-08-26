// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "ComicSans",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "ComicSans", targets: ["ComicSans"]),
        .executable(name: "cs", targets: ["CommandLineTool"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
    ],
    targets: [
        .target(
            name: "ComicSans",
            path: "Sources/Comicsans"
        ),
        .executableTarget(
            name: "CommandLineTool",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ComicSans",
            ],
            path: "Sources/CommandLineTool"
        ),
        .testTarget(
            name: "ComicSansTests",
            dependencies: [
                "ComicSans",
            ],
            path: "Tests/ComicSansTests"
        ),
    ]
)
