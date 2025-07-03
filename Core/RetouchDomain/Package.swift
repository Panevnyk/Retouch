// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RetouchDomain",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "RetouchDomain",
            targets: ["RetouchDomain"]),
    ],
    targets: [
        .target(
            name: "RetouchDomain"),
        .testTarget(
            name: "RetouchDomainTests",
            dependencies: ["RetouchDomain"]
        ),
    ]
)
