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

    await store.send(.logIn) {
      $0 = .loggingIn
    }

    await store.receive(.loggedIn(Session.mock.login)) {
      $0 = .loggedIn(Session.mock.login)
    }
  }

  func testLogout() async {
    let feature = LoginFeature()
    let store = TestStore(
      initialState: .loggedIn("Test"),
      reducer: feature
    )

    await store.send(.logOut) {
      $0 = .loggingIn
    }

    await store.receive(.logOut) {
      $0 = .login(.init(userName: "", password: ""))
    }
  }

  func testReadExistingLogin() async {
    let feature = LoginFeature()
    let store = TestStore(
      initialState: .login(.init()),
      reducer: feature
    )

    await store.send(.start)

    await store.receive(.loggedIn(Session.mock.login)) {
      $0 = .loggedIn(Session.mock.login)
    }
  }
}
