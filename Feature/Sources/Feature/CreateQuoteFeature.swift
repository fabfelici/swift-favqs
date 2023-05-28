import ComposableArchitecture

import Domain
import UseCase

public struct CreateQuoteFeature: ReducerProtocol {

  public struct State: Equatable {
    public var author: String
    public var body: String
    public var status: Status

    public var isSaveEnabled: Bool {
      self.status == .editing && !self.author.isEmpty && !self.body.isEmpty
    }

    public enum Status: Equatable {
      case editing
      case saving
      case failed
    }

    public init(
      author: String = "",
      body: String = "",
      status: Status = .editing
    ) {
      self.author = author
      self.body = body
      self.status = status
    }
  }

  public enum Action: Equatable {
    case bodyText(String)
    case authorText(String)
    case save
    case saved(TaskResult<Quote>)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      guard case .editing = state.status else { return .none }

      switch action {

      case let .bodyText(text):
        state.body = text
        return .none

      case let .authorText(text):
        state.author = text
        return .none

      case .save:
        state.status = .saving
        return .task { [state = state] in
          await .saved(
            TaskResult {
              try await UseCases.createQuote(
                author: state.author,
                body: state.body
              )
            }
          )
        }

      case .saved:
        return .none
      }
    }

    Reduce { state, action in
      guard case .saving = state.status else { return .none }

      switch action {

      case .saved(.success):
        state = .init()
        return .none

      case .saved(.failure):
        state.status = .editing
        return .none

      case .bodyText, .authorText, .save:
        return .none
      }
    }
  }
}

