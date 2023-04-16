import ComposableArchitecture

import UseCase

public struct LoginFeature: ReducerProtocol {

  public enum State: Equatable {
    case login(LoginState)
    case loggingIn
    case loggedIn(String)

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
    case logIn
    case logOut
    case failure
    case loggedIn(String)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      guard case .loggingIn = state else { return .none }

      switch action {

      case let .loggedIn(login):
        state = .loggedIn(login)
        return .none

      case .failure, .logOut:
        state = .login(.init())
        return .none

      case .logIn, .passwordText, .userNameText, .start:
        return .none
      }
    }

    Reduce { state, action in
      guard case let .login(payload) = state else { return .none }
      
      switch action {

      case .logIn:
        state = .loggingIn
        return .run { send in
          do {
            let session = try await UseCases.createSession(
              username: payload.userName,
              password: payload.password
            )
            await send(.loggedIn(session.login))
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
            let session = try await UseCases.readSession()
            await send(.loggedIn(session.login))
          } catch {
            await send(.failure)
          }
        }

      case .failure, .logOut:
        return .none
      }
    }

    Reduce { state, action in
      guard case .loggedIn = state else { return .none }

      switch action {

      case .logOut:
        state = .loggingIn
        return .run { send in
          do {
            try await UseCases.destroySession()
            await send(.logOut)
          } catch {
            await send(.failure)
          }
        }

      case .passwordText, .userNameText, .start, .failure, .loggedIn, .logIn:
        return .none
      }
    }
  }
}
