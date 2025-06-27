// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "brevo-kit",
    platforms: [.macOS(.v10_15), .macCatalyst(.v13), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1)],
    products: [.library(name: "BrevoKit", targets: ["BrevoKit"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "BrevoKit",
            dependencies: [
                .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "brevo-kitTests",
            dependencies: ["BrevoKit"]
        ),
    ]
)
