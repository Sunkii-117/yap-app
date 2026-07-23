// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "coachmetrics",
    targets: [
        .executableTarget(name: "coachmetrics", path: "Sources/coachmetrics")
    ]
)
