// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RetouchMore",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "RetouchMore",
            targets: ["RetouchMore"]),
    ],
    dependencies: [
        .package(path: "../RetouchUtils"),
        .package(path: "../RetouchDesignSystem"),
        .package(path: "../RetouchNetworking"),
        .package(url: "https://github.com/hmlongco/Factory", from: "2.5.3")
    ],
    targets: [
        .target(
            name: "RetouchMore",
            dependencies: [
                "RetouchUtils",
                "RetouchDesignSystem",
                "RetouchNetworking",
                .product(name: "FactoryKit", package: "Factory")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "RetouchMoreTests",
            dependencies: ["RetouchMore"]
        ),
    ]
)
