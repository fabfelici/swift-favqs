import XCTest

import ComposableArchitecture

import Domain
@testable import Feature

@MainActor
final class QuotesFeatureTests: XCTestCase {

  func testLoading() async {
    let clock = TestClock()
    let feature = QuotesFeature()
    let store = TestStore(initialState: .init(), reducer: feature) {
      $0.continuousClock = clock
    }

    await store.send(.start)
    await clock.advance(by: .seconds(0.3))
    await store.receive(.loaded(.success(.init(quotes: [.mock], lastPage: true)))) {
      $0.page = 1
      $0.status = .loaded
      $0.lastPage = true
      $0.quotes = [.mock]
    }
  }

  func testNotLoadingIfLastPage() async {
    let clock = TestClock()
    let feature = QuotesFeature()
    let store = TestStore(initialState: .init(), reducer: feature) {
      $0.continuousClock = clock
    }

    await store.send(.start)
    await clock.advance(by: .seconds(0.3))
    await store.receive(.loaded(.success(.init(quotes: [.mock], lastPage: true)))) {
      $0.page = 1
      $0.status = .loaded
      $0.lastPage = true
      $0.quotes = [.mock]
    }
    await store.send(.loadNext)
    await store.send(.loadNext)
  }

  func testRefreshWhenFailed() async {
    let clock = TestClock()
    let feature = QuotesFeature()
    let store = TestStore(initialState: .init(status: .failed), reducer: feature) {
      $0.continuousClock = clock
    }

    await store.send(.start) {
      $0.status = .loading
    }

    await clock.advance(by: .seconds(0.3))
    await store.receive(.loaded(.success(.init(quotes: [.mock], lastPage: true)))) {
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
    await store.receive(.updateQuote(.success(Quote.mock)))
  }

  func testUpdateQuoteWithoutSession() async {
    let error = RepositoryError(message: "123", errorCode: .userSessionNotFound)
    let feature = QuotesFeature()
    let store = TestStore(initialState: .init(status: .loaded, quotes: [.mock]), reducer: feature)
    store.dependencies.sessionRepository.read = { throw error }
    await store.send(.update(Quote.mock.id, .fav))
    await store.receive(.updateQuote(.failure(error)))
  }

  func testSearch() async {
    let clock = TestClock()
    let feature = QuotesFeature()
    let store = TestStore(initialState: .init(status: .loaded), reducer: feature) {
      $0.continuousClock = clock
    }

    await store.send(.searchText("Text")) {
      $0 = .init()
      $0.searchText = "Text"
    }

    await clock.advance(by: .seconds(0.3))
    await store.receive(.loaded(.success(.init(quotes: [.mock], lastPage: true)))) {
      $0.page = 1
      $0.status = .loaded
      $0.lastPage = true
      $0.quotes = [.mock]
    }
  }
}
