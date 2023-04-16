// swift-tools-version:5.7

import Foundation
import PackageDescription

var package = Package(
  name: "Domain",
  platforms: [
    .iOS(.v13),
    .macOS(.v11)
  ],
  products: [
    .library(name: "Domain", targets: ["Domain"])
  ],
  dependencies: [],
  targets: [
    .target(name: "Domain")
  ]
)
