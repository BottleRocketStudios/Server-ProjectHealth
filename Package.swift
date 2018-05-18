// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "ProjectHealth",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.2"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0-rc"),
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc.2.3"),
        .package(url: "https://github.com/vapor/crypto.git", from: "3.1.0"),
        .package(url: "https://github.com/LiveUI/XMLCoding.git", from: "0.0.1")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentPostgreSQL", "Authentication", "Crypto", "XMLCoding"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"]),
        ]
)
