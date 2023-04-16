import ComposableArchitecture

import Domain
import UseCase

public struct QuotesFeature: ReducerProtocol {

  public struct State: Equatable {

    public enum Status: Equatable {
      case loading
      case loaded
      case failed
    }

    public var status: Status
    public var page: Int
    public var quotes: [Quote]
    public var lastPage: Bool

    public init(
      status: QuotesFeature.State.Status = .loading,
      page: Int = 1,
      quotes: [Quote] = [],
      lastPage: Bool = false
    ) {
      self.status = status
      self.page = page
      self.quotes = quotes
      self.lastPage = lastPage
    }
  }

  public enum Action: Equatable {
    case start
    case loadNext
    case loaded(QuotePage)
    case failure
    case update(Int, QuoteRepository.UpdateQuoteType)
    case updateQuote(Int, Quote)
  }

  public var body: some ReducerProtocol<State, Action> {

    Reduce { state, action in
      guard case .loading = state.status else { return .none }

      switch action {
      case .start:
        return .task { [page = state.page] in
        do {
          let page = try await UseCases.quotes(
            parameters: .init(page: page)
          )
          return .loaded(page)
        } catch {
          return .failure
        }
      }

      case .failure:
        state.status = .failed
        return .none

      case let .loaded(page):
        state.status = .loaded
        state.lastPage = page.lastPage
        state.quotes += page.quotes
        return .none

      case .loadNext,
          .updateQuote,
          .update:
        return .none
      }
    }

    Reduce { state, action in
      guard case .loaded = state.status else { return .none }

      switch action {
      case .start:
        state = .init()
        return .send(.start)

      case .loadNext:
        guard !state.lastPage else { return .none }
        state.page += 1
        state.status = .loading
        return .send(.start)

      case let .update(id, type):
        return .run { send in
          do {
            let quote = try await UseCases.updateQuote(id: id, type: type)
            await send(.updateQuote(id, quote))
          } catch {
            await send(.failure)
          }
        }

      case let .updateQuote(id, newQuote):
        let firstIndex = state.quotes.firstIndex(where: {
          $0.id == id
        })
        if let index = firstIndex {
          state.quotes[index] = newQuote
        }
        return .none

      case .loaded, .failure:
        return .none
      }
    }

    Reduce { state, action in
      guard case .failed = state.status else { return .none }

      switch action {
      case .start:
        state = .init()
        return .send(.start)

      case .loadNext:
        guard !state.lastPage else { return .none }
        state.status = .loading
        return .send(.start)

      case .failure,
          .loaded,
          .update,
          .updateQuote:
        return .none
      }
    }
  }
}
