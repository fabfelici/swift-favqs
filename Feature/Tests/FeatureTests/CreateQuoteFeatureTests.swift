import XCTest

import ComposableArchitecture

import Domain
@testable import Feature

@MainActor
final class CreateQuoteFeatureTests: XCTestCase {

  func testEditing() async {
    let feature = CreateQuoteFeature()
    let store = TestStore(initialState: .init(), reducer: feature)

    await store.send(.authorText("Author")) {
      $0.author = "Author"
    }

    await store.send(.bodyText("Just a quote")) {
      $0.body = "Just a quote"
    }
  }

  func testSavingSuccess() async {
    let feature = CreateQuoteFeature()
    let store = TestStore(
      initialState: .init(
        author: "Author",
        body: "Just a quote"
      ),
      reducer: feature
    )

    await store.send(.save) {
      $0.status = .saving
    }

    await store.receive(.saved(.success(.mock))) {
      $0 = .init()
    }
  }

  func testSavingFailure() async {
    let error = RepositoryError(message: "Error", errorCode: .invalidRequest)
    let feature = CreateQuoteFeature()
    let store = TestStore(
      initialState: .init(
        author: "Author",
        body: "Just a quote"
      ),
      reducer: feature
    ) {
      $0.quoteRepository.create = { _, _, _ in
        throw error
      }
    }

    await store.send(.save) {
      $0.status = .saving
    }

    await store.receive(.saved(.failure(error))) {
      $0.status = .editing
    }
  }
}
