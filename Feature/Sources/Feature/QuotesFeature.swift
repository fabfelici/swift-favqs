import ComposableArchitecture

import Domain
import UseCase

extension Quote: Identifiable { }

public struct QuotesFeature: ReducerProtocol {

  public struct State: Equatable {

    public enum Status: Equatable {
      case loading
      case loaded
      case failed
    }

    public var status: Status
    public var page: Int
    public var quotes: IdentifiedArrayOf<Quote>
    public var lastPage: Bool
    public var searchText: String

    public init(
      status: QuotesFeature.State.Status = .loading,
      page: Int = 1,
      quotes: [Quote] = [],
      lastPage: Bool = false,
      searchText: String = ""
    ) {
      self.status = status
      self.page = page
      self.quotes = .init(uniqueElements: quotes)
      self.lastPage = lastPage
      self.searchText = searchText
    }
  }

  public enum Action: Equatable {
    case start
    case loadNext
    case loaded(TaskResult<QuotePage>)
    case update(Quote.ID, QuoteRepository.UpdateQuoteType)
    case updateQuote(TaskResult<Quote>)
    case searchText(String)
  }

  @Dependency(\.continuousClock) var clock

  enum CancelQuotesId { }

  public var body: some ReducerProtocol<State, Action> {

    Reduce { state, action in
      switch action {
      case let .searchText(text):
        state = .init()
        state.searchText = text
        return load(state: &state)

      default:
        return .none
      }
    }

    Reduce { state, action in
      guard case .loading = state.status else { return .none }

      switch action {
      case .start:
        return load(state: &state)

      case .loaded(.failure):
        state.status = .failed
        return .none

      case let .loaded(.success(page)):
        state.status = .loaded
        state.lastPage = page.lastPage
        state.quotes += page.quotes
        return .none

      case .loadNext,
          .updateQuote,
          .update,
          .searchText:
        return .none
      }
    }

    Reduce { state, action in
      guard case .loaded = state.status else { return .none }

      switch action {
      case .start:
        let searchText = state.searchText
        state = .init()
        state.searchText = searchText
        return load(state: &state)

      case .loadNext:
        guard !state.lastPage else { return .none }
        state.page += 1
        state.status = .loading
        return load(state: &state)

      case let .update(id, type):
        return .task {
          await .updateQuote(
            .init {
              try await UseCases.updateQuote(id: id, type: type)
            }
          )
        }

      case let .updateQuote(.success(newQuote)):
        state.quotes[id: newQuote.id] = newQuote
        return .none

      case .loaded,
          .updateQuote(.failure),
          .searchText:
        return .none
      }
    }

    Reduce { state, action in
      guard case .failed = state.status else { return .none }

      switch action {
      case .start:
        state = .init()
        return load(state: &state)

      case .loadNext:
        guard !state.lastPage else { return .none }
        state.status = .loading
        return load(state: &state)

      case .loaded,
          .update,
          .updateQuote,
          .searchText:
        return .none
      }
    }
  }

  private func load(state: inout State) -> EffectTask<Action> {
    return .task { [state = state] in
      try await self.clock.sleep(for: .seconds(0.3))
      return await .loaded(
        .init {
          try await UseCases.quotes(
            parameters: .init(
              filter: state.searchText,
              page: state.page
            )
          )
        }
      )
    }
    .cancellable(id: CancelQuotesId.self, cancelInFlight: true)
  }
}
