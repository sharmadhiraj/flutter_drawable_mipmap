// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "flutter_drawable_mipmap",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "flutter-drawable-mipmap", targets: ["flutter_drawable_mipmap"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "flutter_drawable_mipmap",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
