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
    case loaded(User)
    case logout
    case refresh
  }

  public var body: some ReducerProtocol<State, Action> {

    Scope(state: /ProfileFeature.State.login, action: /Action.login, child: LoginFeature.init)

    Reduce { state, action in
      switch action {
      case let .login(.loggedIn(user)), let .loaded(user):
        state = .profile(user)
        return .none

      case .logout:

        guard case let .profile(user) = state else { return .none }

        state = .login(.loggedIn(user))
        return .send(.login(.logout))

      case .refresh:
        return .run { send in
          do {
            let user = try await UseCases.readUser(login: nil)
            await send(.loaded(user))
          } catch {
            return
          }
        }

      default:
        return .none
      }
    }
  }
}
