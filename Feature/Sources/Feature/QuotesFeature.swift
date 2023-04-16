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

    public var status: Status = .loading
    public var page: Int = 1
    public var quotes: [Quote] = []
    public var lastPage = false
  }

  public enum Action: Equatable {
    case start
    case loadNext
    case loaded(QuotePage)
    case failure
    case upvote(Int)
    case downvote(Int)
    case clearvote(Int)
    case favorite(Int)
    case unfavorite(Int)
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
          .upvote,
          .favorite,
          .downvote,
          .updateQuote,
          .unfavorite,
          .clearvote:
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

      case let .upvote(id):
        return .run { send in
          do {
            let quote = try await UseCases.upvoteQuote(id: id)
            await send(.updateQuote(id, quote))
          } catch {
            await send(.failure)
          }
        }

      case let .downvote(id):
        return .run { send in
          do {
            let quote = try await UseCases.downvoteQuote(id: id)
            await send(.updateQuote(id, quote))
          } catch {
            await send(.failure)
          }
        }

      case let .favorite(id):
        return .run { send in
          do {
            let quote = try await UseCases.favoriteQuote(id: id)
            await send(.updateQuote(id, quote))
          } catch {
            await send(.failure)
          }
        }

      case let .unfavorite(id):
        return .run { send in
          do {
            let quote = try await UseCases.unFavoriteQuote(id: id)
            await send(.updateQuote(id, quote))
          } catch {
            await send(.failure)
          }
        }

      case let .clearvote(id):
        return .run { send in
          do {
            let quote = try await UseCases.clearVoteQuote(id: id)
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
          .upvote,
          .favorite,
          .downvote,
          .updateQuote,
          .unfavorite,
          .clearvote:
        return .none
      }
    }
  }
}
