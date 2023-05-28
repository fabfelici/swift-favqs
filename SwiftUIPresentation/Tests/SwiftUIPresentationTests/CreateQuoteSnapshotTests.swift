import XCTest
import SwiftUI

import SnapshotTesting
import ComposableArchitecture

@testable import Feature
@testable import SwiftUIPresentation

@MainActor
final class CreateQuoteSnapshotTests: XCTestCase {

  func testCreateQuoteView() {
    let view = CreateQuoteView(
      store: .init(
        initialState: .init(),
        reducer: EmptyReducer()
      )
    )
    assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone13Pro)))
  }
}
