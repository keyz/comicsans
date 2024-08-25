// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "comicsans",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(name: "ComicSans", targets: ["ComicSans"]),
        .executable(name: "ComicSansCLI", targets: ["ComicSansCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
    ],
    targets: [
        .target(name: "ComicSans"),
        .executableTarget(
            name: "ComicSansCLI",
            dependencies: [
                "ComicSans",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "ComicSansTests",
            dependencies: [
                "ComicSans",
            ]
        ),
    ]
)
