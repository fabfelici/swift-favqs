import ComposableArchitecture

import Domain
import UseCase

public struct ProfileFeature: ReducerProtocol {

  public enum State: Equatable {
    case login(LoginFeature.State)
    case profile(User)
  }

  public enum Action: Equatable {
    case login(LoginFeature.Action)
    case loaded(TaskResult<User>)
    case logout
    case loggedOut
    case refresh
  }

  public var body: some ReducerProtocol<State, Action> {

    Scope(state: /ProfileFeature.State.login, action: /Action.login, child: LoginFeature.init)

    Reduce { state, action in
      switch action {
      case let .login(.loggedIn(.success(user))), let .loaded(.success(user)):
        state = .profile(user)
        return .none

      case .logout:
        state = .login(.loggingIn)
        return .task {
          try await UseCases.logout()
          return .loggedOut
        }

      case .refresh:
        return .task {
          await .loaded(
            .init {
              try await UseCases.readUser()
            }
          )
        }

      case .loggedOut:
        state = .login(.login(.init()))
        return .none

      default:
        return .none
      }
    }
  }
}
