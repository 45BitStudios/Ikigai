// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport
import Foundation

let package = Package(
    name: "IkigaiAPI",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .visionOS(.v2),
        .tvOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: "IkigaiCore",
            targets: ["IkigaiCore"]
        ),
        .library(
            name: "IkigaiAI",
            targets: ["IkigaiAI"]
        ),
        .library(
            name: "IkigaiUI",
            targets: ["IkigaiUI"]
        ),
        .library(
            name: "IkigaiMacros",
            targets: ["IkigaiMacros"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.1"),
    ],
    targets: [
        .target(
            name: "IkigaiCore"
        ),
        .target(
            name: "IkigaiAI"
        ),
        .target(
            name: "IkigaiUI"
        ),
        .macro(
            name: "IkigaiMacroPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "IkigaiMacros",
                dependencies: [
                    "IkigaiMacroPlugin"
                ]
        ),
        .testTarget(
            name: "IkigaiCoreTests",
            dependencies: ["IkigaiCore"]
        ),
        .testTarget(
            name: "IkigaiAITests",
            dependencies: ["IkigaiAI"]
        ),
        .testTarget(
            name: "IkigaiUITests",
            dependencies: ["IkigaiUI"]
        ),
        .testTarget(
            name: "IkigaiMacrosTests",
            dependencies: [
                "IkigaiMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
