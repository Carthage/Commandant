import PackageDescription

let package = Package(
  name: "Commandant",
  dependencies: [
    .Package(url: "https://github.com/jpsim/Result.git", majorVersion: 1)
  ]
)
