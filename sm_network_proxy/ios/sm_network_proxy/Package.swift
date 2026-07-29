// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "sm_network_proxy",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "sm-network-proxy", targets: ["sm_network_proxy"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "sm_network_proxy",
            dependencies: []
        )
    ]
)
