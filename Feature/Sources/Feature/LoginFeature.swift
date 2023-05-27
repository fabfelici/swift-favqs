import ComposableArchitecture

import Domain
import UseCase

public struct LoginFeature: ReducerProtocol {

  public enum State: Equatable {
    case login(LoginState)
    case loggingIn

    public struct LoginState: Equatable {
      public var userName: String
      public var password: String

      public init(
        userName: String = "",
        password: String = ""
      ) {
        self.userName = userName
        self.password = password
      }
    }
  }

  public enum Action: Equatable {
    case start
    case userNameText(String)
    case passwordText(String)
    case login
    case loggedIn(TaskResult<User>)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      guard case .loggingIn = state else { return .none }

      switch action {

      case .loggedIn(.failure):
        state = .login(.init())
        return .none

      case .login, .passwordText, .userNameText, .start, .loggedIn(.success):
        return .none
      }
    }

    Reduce { state, action in
      guard case let .login(payload) = state else { return .none }
      
      switch action {

      case .login:
        state = .loggingIn
        return .task {
          await .loggedIn(
            TaskResult {
              try await UseCases.login(
                username: payload.userName,
                password: payload.password
              )
            }
          )
        }

      case let .passwordText(password):
        state = .login(.init(userName: payload.userName, password: password))
        return .none

      case let .userNameText(userName):
        state = .login(.init(userName: userName, password: payload.password))
        return .none

      case .start:
        return .task {
          await .loggedIn(
            TaskResult {
              try await UseCases.readUser()
            }
          )
        }

      case .loggedIn:
        return .none
      }
    }
  }
}
