// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "captain",
    products: [
        .executable(name: "captain", targets: ["captain"]),
        .library(name: "CaptainKit", targets: ["CaptainKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.15.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "1.0.2"),
        .package(url: "https://github.com/thoughtbot/Curry.git", from: "4.0.2"),
    ],
    targets: [
        .target(name: "captain", dependencies: ["Commandant", "Curry", "CaptainKit"]),
        .target(name: "CaptainKit", dependencies: ["Yams"]),
    ]
)