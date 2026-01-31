// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "EMDRlyBridge",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .visionOS(.v1),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "EMDRlyBridge",
            targets: ["EMDRlyBridge"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MeansAI/JBS.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "EMDRlyBridge",
            dependencies: [
                .product(name: "JBS", package: "JBS"),
            ]),
        .testTarget(
            name: "EMDRlyBridgeTests",
            dependencies: ["EMDRlyBridge"]),
    ]
)
