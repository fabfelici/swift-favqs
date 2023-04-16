import XCTest
import SwiftUI

import SnapshotTesting
import ComposableArchitecture

@testable import Feature
@testable import SwiftUIPresentation

@MainActor
final class AppSnapshotTests: XCTestCase {

  func testQuotesWithTab() {
    let view = AppView(
      store: .init(
        initialState: .init(quotes: .init(quotes: [.mock])),
        reducer: EmptyReducer()
      )
    )
    assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone13Pro)))
  }
}
