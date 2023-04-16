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
    case refresh
  }

  public var body: some ReducerProtocol<State, Action> {

    Reduce { state, action in
      switch action {
      case let .login(.loggedIn(login)):
        return .run { send in
          do {
            let user = try await UseCases.readUser(login: login)
            await send(.loaded(user))
          } catch {
            return
          }
        }

      case let .loaded(user):
        state = .profile(user)
        return .none

      case .login(.logOut):

        guard case let .profile(user) = state else { return .none }

        state = .login(.loggedIn(user.login))
        return .send(.login(.logOut))

      case .refresh:
        return .run { send in
          do {
            let login = try await UseCases.readSession().login
            let user = try await UseCases.readUser(login: login)
            await send(.loaded(user))
          } catch {
            return
          }
        }

      default:
        return .none
      }
    }

    Scope(state: /ProfileFeature.State.login, action: /Action.login, child: LoginFeature.init)
  }
}
