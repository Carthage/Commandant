import PackageDescription

let package = Package(
  name: "Commandant",
  dependencies: [
    .Package(url: "https://github.com/antitypical/Result.git", "3.0.0-alpha.4")
  ]
)
