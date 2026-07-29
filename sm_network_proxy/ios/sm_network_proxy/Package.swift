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
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "sm_network_proxy",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
