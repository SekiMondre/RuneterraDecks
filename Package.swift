// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "RuneterraDecks",
    products: [
        .library(
            name: "RuneterraDecks",
            targets: ["RuneterraDecks"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RuneterraDecks",
            dependencies: []),
        .testTarget(
            name: "RuneterraDecksTests",
            dependencies: ["RuneterraDecks"],
            resources: [
                .process("TestData")
            ]
        ),
    ]
)
