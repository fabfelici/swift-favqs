import ComposableArchitecture

import Domain
import UseCase

public struct LoginFeature: ReducerProtocol {

  public enum State: Equatable {
    case login(LoginState)
    case loggingIn
    case loggedIn(User)

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
    case logout
    case failure
    case loggedIn(User)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      guard case .loggingIn = state else { return .none }

      switch action {

      case let .loggedIn(user):
        state = .loggedIn(user)
        return .none

      case .failure, .logout:
        state = .login(.init())
        return .none

      case .login, .passwordText, .userNameText, .start:
        return .none
      }
    }

    Reduce { state, action in
      guard case let .login(payload) = state else { return .none }
      
      switch action {

      case .login:
        state = .loggingIn
        return .run { send in
          do {
            let user = try await UseCases.login(
              username: payload.userName,
              password: payload.password
            )
            await send(.loggedIn(user))
          } catch {
            await send(.failure)
          }
        }

      case let .passwordText(password):
        state = .login(.init(userName: payload.userName, password: password))
        return .none

      case let .userNameText(userName):
        state = .login(.init(userName: userName, password: payload.password))
        return .none

      case let .loggedIn(login):
        state = .loggedIn(login)
        return .none

      case .start:
        return .run { send in
          do {
            let user = try await UseCases.readUser(login: nil)
            await send(.loggedIn(user))
          } catch {
            await send(.failure)
          }
        }

      case .failure, .logout:
        return .none
      }
    }

    Reduce { state, action in
      guard case .loggedIn = state else { return .none }

      switch action {

      case .logout:
        state = .loggingIn
        return .run { send in
          do {
            try await UseCases.logout()
            await send(.logout)
          } catch {
            await send(.failure)
          }
        }

      case .passwordText, .userNameText, .start, .failure, .loggedIn, .login:
        return .none
      }
    }
  }
}
