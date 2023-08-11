// swift-tools-version:5.7

import Foundation
import PackageDescription

var package = Package(
  name: "UseCase",
  platforms: [
    .iOS(.v13),
    .macOS(.v11)
  ],
  products: [
    .library(name: "UseCase", targets: ["UseCase"])
  ],
  dependencies: [
    .package(path: "../Domain"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.2.0"),
  ],
  targets: [
    .target(name: "UseCase", dependencies: [
      "Domain",
      .product(name: "Dependencies", package: "swift-dependencies"),
    ])
  ]
)
