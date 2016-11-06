import PackageDescription

let package = Package(
    name: "Commandant",
    dependencies: [
        .Package(url: "https://github.com/antitypical/Result.git", majorVersion: 3, minor: 0),
        .Package(url: "https://github.com/Quick/Nimble", majorVersion: 5),
        .Package(url: "https://github.com/Quick/Quick", majorVersion: 0, minor: 10),
    ]
)
