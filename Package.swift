import PackageDescription

let package = Package(
    name: "Commandant",
    dependencies: [
        .Package(url: "https://github.com/antitypical/Result.git", versions: Version(3, 2, 1)..<Version(3, .max, .max)),
    ]
)
