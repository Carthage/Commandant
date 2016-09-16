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
                .Package(url: "https://github.com/ikesyo/Nimble", "5.0.0-alpha.30.gm.candidate"),
                .Package(url: "https://github.com/norio-nomura/Quick", "0.10.0-alpha.30.gm.candidate"),
            ]
        #endif
    }()
)
