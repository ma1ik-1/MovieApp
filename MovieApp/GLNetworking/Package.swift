// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GLNetworking",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GLNetworking",
            targets: ["GLNetworking"]
        ),
        .library(
            name: "MockNetworking",
            targets: ["MockNetworking"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GLNetworking",
            dependencies: []
        ),
        .target(
            name: "MockNetworking",
            dependencies: [
                "GLNetworking"
            ]
        ),
        .testTarget(
            name: "GLNetworkingTests",
            dependencies: [
                "GLNetworking",
                "MockNetworking"
            ]
        )
    ]
)
