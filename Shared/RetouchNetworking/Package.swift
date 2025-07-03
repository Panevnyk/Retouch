// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RetouchNetworking",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "RetouchNetworking",
            targets: ["RetouchNetworking"]),
    ],
    targets: [
        .target(
            name: "RetouchNetworking"),
        .testTarget(
            name: "RetouchNetworkingTests",
            dependencies: ["RetouchNetworking"]
        ),
    ]
)
