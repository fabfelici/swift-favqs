// swift-tools-version:5.7

import Foundation
import PackageDescription

var package = Package(
  name: "Feature",
  platforms: [
    .iOS(.v16),
    .macOS(.v11)
  ],
  products: [
    .library(name: "Feature", targets: ["Feature"]),
  ],
  dependencies: [
    .package(path: "../Domain"),
    .package(path: "../UseCase"),
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      from: "0.52.0"
    ),
  ],
  targets: [
    .target(
      name: "Feature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        "Domain",
        "UseCase"
      ]
    ),
    .testTarget(
      name: "FeatureTests",
      dependencies: [
        "Feature"
      ]
    )
  ]
)
