// swift-tools-version: 6.3.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MirPay-iOS",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MirPay-iOS",
            targets: ["MirPay_iOS"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MirPay_iOS",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "MirPay_iOSTests",
            dependencies: ["MirPay_iOS"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ]
)
