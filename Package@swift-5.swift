// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Commandant",
    products: [
        .library(name: "Commandant", targets: ["Commandant"])
    ],
    dependencies: [
        .package(url: "https://github.com/antitypical/Result.git", from: "4.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "1.3.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.3.0")
    ],
    targets: [
        .target(name: "Commandant", dependencies: ["Result"]),
        .testTarget(name: "CommandantTests", dependencies: ["Commandant", "Quick", "Nimble"])
    ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)
