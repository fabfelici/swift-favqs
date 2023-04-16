import XCTest

import ComposableArchitecture

@testable import Domain
@testable import Feature

@MainActor
final class ProfileFeatureTests: XCTestCase {

  func testLogin() async {
    let feature = ProfileFeature()
    let store = TestStore(
      initialState: .login(.login(.init())),
      reducer: feature
    )

    await store.send(.login(.logIn)) {
      $0 = .login(.loggingIn)
    }

    await store.receive(.login(.loggedIn(Session.mock.login))) {
      $0 = .login(.loggedIn(Session.mock.login))
    }

    await store.receive(.loaded(.mock)) {
      $0 = .profile(.mock)
    }
  }

  func testLogout() async {
    let feature = ProfileFeature()
    let store = TestStore(
      initialState: .profile(.mock),
      reducer: feature
    )

    await store.send(.login(.logOut)) {
      $0 = .login(.loggingIn)
    }

    await store.receive(.login(.logOut)) {
      $0 = .login(.login(.init(userName: "", password: "")))
    }
  }

  func testReadExistingLogin() async {
    let feature = ProfileFeature()
    let store = TestStore(
      initialState: .login(.login(.init())),
      reducer: feature
    )

    await store.send(.login(.start))

    await store.receive(.login(.loggedIn(Session.mock.login))) {
      $0 = .login(.loggedIn(Session.mock.login))
    }

    await store.receive(.loaded(.mock)) {
      $0 = .profile(.mock)
    }
  }
}
