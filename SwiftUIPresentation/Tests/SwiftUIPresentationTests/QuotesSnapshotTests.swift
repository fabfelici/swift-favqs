import XCTest
import SwiftUI

import SnapshotTesting
import ComposableArchitecture

@testable import Feature
@testable import SwiftUIPresentation

@MainActor
final class QuotesSnapshotTests: XCTestCase {

  func testLoadedQuotes() {
    let view = NavigationView {
      QuotesView(
        store: .init(
          initialState: .init(quotes: [.mock]),
          reducer: EmptyReducer()
        )
      )
    }
    assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone13Pro)))
  }

  func testFailedLoadingQuotes() {
    let view = NavigationView {
      QuotesView(
        store: .init(
          initialState: .init(status: .failed),
          reducer: EmptyReducer()
        )
      )
    }
    assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone13Pro)))
  }

}
