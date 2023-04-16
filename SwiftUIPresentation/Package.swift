// swift-tools-version:5.7

import Foundation
import PackageDescription

var package = Package(
  name: "SwiftUIPresentation",
  platforms: [
    .iOS(.v15),
    .macOS(.v12)
  ],
  products: [
    .library(name: "SwiftUIPresentation", targets: ["SwiftUIPresentation"]),
  ],
  dependencies: [
    .package(path: "../Domain"),
    .package(path: "../Feature"),
    .package(
      url: "https://github.com/pointfreeco/swift-snapshot-testing",
      from: "1.9.0"
    ),
  ],
  targets: [
    .target(
      name: "SwiftUIPresentation",
      dependencies: [
        "Domain",
        "Feature"
      ]
    ),
    .testTarget(
      name: "SwiftUIPresentationTests",
      dependencies: [
        "SwiftUIPresentation",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
      ],
      exclude: [
        "__Snapshots__"
      ]
    )
  ]
)
