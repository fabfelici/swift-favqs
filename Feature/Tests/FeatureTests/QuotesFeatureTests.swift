import XCTest

import ComposableArchitecture

import Domain
@testable import Feature

@MainActor
final class QuotesFeatureTests: XCTestCase {

  func testLoading() async {
    let feature = QuotesFeature()
    let store = TestStore(initialState: .init(), reducer: feature)

    await store.send(.start)

    await store.receive(.loaded(.init(quotes: [.mock], lastPage: true))) {
      $0.page = 1
      $0.status = .loaded
      $0.lastPage = true
      $0.quotes = [.mock]
    }
  }

  func testNotLoadingIfLastPage() async {
    let feature = QuotesFeature()
    let store = TestStore(initialState: .init(), reducer: feature)

    await store.send(.start)

    await store.receive(.loaded(.init(quotes: [.mock], lastPage: true))) {
      $0.page = 1
      $0.status = .loaded
      $0.lastPage = true
      $0.quotes = [.mock]
    }
    await store.send(.loadNext)
    await store.send(.loadNext)
  }

  func testRefreshWhenFailed() async {
    let feature = QuotesFeature()
    let store = TestStore(initialState: .init(status: .failed), reducer: feature)

    await store.send(.start) {
      $0.status = .loading
    }
    await store.receive(.start)
    await store.receive(.loaded(.init(quotes: [.mock], lastPage: true))) {
      $0.page = 1
      $0.status = .loaded
      $0.lastPage = true
      $0.quotes = [.mock]
    }
  }

  func testFavQuote() async {
    let feature = QuotesFeature()
    let store = TestStore(initialState: .init(status: .loaded, quotes: [.mock]), reducer: feature)

    await store.send(.update(Quote.mock.id, .fav))
    await store.receive(.updateQuote(Quote.mock.id, Quote.mock))
  }

  func testUpdateQuoteWithoutSession() async {
    let feature = QuotesFeature()
    let store = withDependencies {
      $0.sessionRepository.read = {
        throw RepositoryError(message: "123", errorCode: .userSessionNotFound)
      }
    } operation: {
      TestStore(initialState: .init(status: .loaded, quotes: [.mock]), reducer: feature)
    }

    await store.send(.update(Quote.mock.id, .fav))
    await store.receive(.failure)
  }
}
