import XCTest

import ComposableArchitecture

@testable import Domain
@testable import Feature

@MainActor
final class LoginFeatureTests: XCTestCase {

  func testLogin() async {
    let feature = LoginFeature()
    let store = TestStore(
      initialState: .login(.init(userName: "", password: "")),
      reducer: feature
    )

    await store.send(.userNameText("Test")) {
      $0 = .login(.init(userName: "Test", password: ""))
    }

    await store.send(.passwordText("Password")) {
      $0 = .login(.init(userName: "Test", password: "Password"))
    }

    await store.send(.login) {
      $0 = .loggingIn
    }

    await store.receive(.loggedIn(.success(.mock)))
  }

  func testReadExistingLogin() async {
    let feature = LoginFeature()
    let store = TestStore(
      initialState: .login(.init()),
      reducer: feature
    )

    await store.send(.start)

    await store.receive(.loggedIn(.success(.mock)))
  }
}
