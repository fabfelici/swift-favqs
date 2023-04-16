// swift-tools-version:5.7

import Foundation
import PackageDescription

var package = Package(
  name: "UIKitPresentation",
  platforms: [
    .iOS(.v13),
    .macOS(.v11)
  ],
  products: [
    .library(name: "UIKitPresentation", targets: ["UIKitPresentation"]),
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
      name: "UIKitPresentation",
      dependencies: [
        "Domain",
        "Feature"
      ]
    ),
    .testTarget(
      name: "UIKitPresentationTests",
      dependencies: [
        "UIKitPresentation",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
      ]
//      ,
//      exclude: [
//        "__Snapshots__"
//      ]
    )
  ]
)
