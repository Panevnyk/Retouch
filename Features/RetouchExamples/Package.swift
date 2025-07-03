// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RetouchExamples",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "RetouchExamples",
            targets: ["RetouchExamples"]),
    ],
    dependencies: [
        .package(path: "../RetouchUtils"),
        .package(path: "../RetouchDesignSystem"),
        .package(url: "https://github.com/hmlongco/Factory", from: "2.5.3")
    ],
    targets: [
        .target(
            name: "RetouchExamples",
            dependencies: [
                "RetouchUtils",
                "RetouchDesignSystem",
                .product(name: "FactoryKit", package: "Factory")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "RetouchExamplesTests",
            dependencies: ["RetouchExamples"]
        ),
    ]
)
