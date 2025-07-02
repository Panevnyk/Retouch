// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RetouchAnalytics",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RetouchAnalytics",
            targets: ["RetouchAnalytics"]),
    ],
    dependencies: [
        .package(path: "../RetouchUtils"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RetouchAnalytics",
            dependencies: [
                "RetouchUtils",
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk")
            ]
        ),
        .testTarget(
            name: "RetouchAnalyticsTests",
            dependencies: ["RetouchAnalytics"]
        ),
    ]
)
