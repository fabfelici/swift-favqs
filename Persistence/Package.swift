// swift-tools-version:5.7

import Foundation
import PackageDescription

var package = Package(
  name: "Persistence",
  platforms: [
    .iOS(.v13),
    .macOS(.v11)
  ],
  products: [
    .library(name: "Networking", targets: ["Networking"]),
  ],
  dependencies: [
    .package(path: "../Domain"),
    .package(
      url: "https://github.com/pointfreeco/swift-overture",
      from: "0.5.0"
    ),
    .package(name: "ArkanaKeys", path: "Sources/Networking/ArkanaKeys/ArkanaKeys"),
  ],
  targets: [
    .target(
      name: "Networking",
      dependencies: [
        "Domain",
        .product(name: "Overture", package: "swift-overture"),
        "ArkanaKeys"
      ],
      exclude: [
        "Gemfile",
        "Gemfile.lock",
        "ArkanaKeys",
        ".env",
        ".env.template",
        ".arkana.yml"
      ]
    )
  ]
)
