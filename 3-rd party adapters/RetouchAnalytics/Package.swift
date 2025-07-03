// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RetouchAnalytics",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "RetouchAnalytics",
            targets: ["RetouchAnalytics"]),
    ],
    dependencies: [
        .package(path: "../RetouchUtils"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0")
    ],
    targets: [
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
