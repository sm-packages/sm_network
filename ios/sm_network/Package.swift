// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "sm_network",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "sm-network", targets: ["sm_network"])
    ],
    // Flutter 3.24-3.38 injects Flutter at the generated app-package level.
    dependencies: [],
    targets: [
        .target(
            name: "sm_network",
            dependencies: []
        )
    ]
)
