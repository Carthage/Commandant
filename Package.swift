import PackageDescription

let package = Package(
    name: "Commandant",
    dependencies: {
        #if os(macOS)
            return [
                .Package(url: "https://github.com/antitypical/Result.git", majorVersion: 3, minor: 0),
            ]
        #else
            return [
                .Package(url: "https://github.com/antitypical/Result.git", majorVersion: 3, minor: 0),
                .Package(url: "https://github.com/Quick/Nimble", majorVersion: 5, minor: 0),
                .Package(url: "https://github.com/ikesyo/Quick", "0.10.0-alpha.30"),
            ]
        #endif
    }()
)
