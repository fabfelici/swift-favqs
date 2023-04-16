import XCTest
import SwiftUI

import SnapshotTesting
import ComposableArchitecture

@testable import Feature
@testable import SwiftUIPresentation

@MainActor
final class ProfileSnapshotTests: XCTestCase {

  func testLogin() {
    let view = MainProfileView(
      store: .init(
        initialState: .login(.login(.init())),
        reducer: EmptyReducer()
      )
    )
    assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone13Pro)))
  }

  func testLogginIn() {
    let view = MainProfileView(
      store: .init(
        initialState: .login(.loggingIn),
        reducer: EmptyReducer()
      )
    )
    assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone13Pro)))
  }

  func testLoggedIn() {
    let view = MainProfileView(
      store: .init(
        initialState: .profile(.mock),
        reducer: EmptyReducer()
      )
    )
    assertSnapshot(matching: view, as: .image(layout: .device(config: .iPhone13Pro)))
  }
}
