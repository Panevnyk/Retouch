// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RetouchUtils",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RetouchUtils",
            targets: ["RetouchUtils"]),
    ],
    dependencies: [
        .package(path: "../RetouchDomain"),
        .package(url: "https://github.com/hmlongco/Factory", from: "2.5.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RetouchUtils",
            dependencies: [
                "RetouchDomain",
                .product(name: "FactoryKit", package: "Factory")
            ]
        ),
        .testTarget(
            name: "RetouchUtilsTests",
            dependencies: ["RetouchUtils"]
        ),
    ]
)
