// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RetouchImageLoader",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "RetouchImageLoader",
            targets: ["RetouchImageLoader"]),
    ],
    dependencies: [
        .package(path: "../RetouchUtils"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "RetouchImageLoader",
            dependencies: [
                "RetouchUtils",
                .product(name: "Kingfisher", package: "Kingfisher")
            ]
        ),
        .testTarget(
            name: "RetouchImageLoaderTests",
            dependencies: ["RetouchImageLoader"]
        ),
    ]
)
