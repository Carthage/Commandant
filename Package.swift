import PackageDescription

let package = Package(
  name: "Commandant",
  dependencies: [
    .Package(url: "https://github.com/antitypical/Result.git", "3.0.0-alpha.1"),
    .Package(url: "https://github.com/norio-nomura/Nimble", "5.0.0-alpha.30p2"),
    .Package(url: "https://github.com/norio-nomura/Quick", "0.10.0-alpha.1"),
  ]
)
