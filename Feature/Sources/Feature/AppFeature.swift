import ComposableArchitecture

public struct AppFeature: ReducerProtocol {

  public struct State: Equatable {
    public var quotes: QuotesFeature.State

    public var profile: ProfileFeature.State

    public init(
      quotes: QuotesFeature.State = .init(),
      profile: ProfileFeature.State = .login(.login(.init()))
    ) {
      self.quotes = quotes
      self.profile = profile
    }
  }

  public enum Action {
    case quotes(QuotesFeature.Action)
    case profile(ProfileFeature.Action)
  }

  public init() { }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .profile(.loggedOut), .profile(.login(.loggedIn(.success))):
        state.quotes = .init()
        return .none

      default:
        return .none
      }
    }

    Scope(state: \.quotes, action: /Action.quotes, child: QuotesFeature.init)
    Scope(state: \.profile, action: /Action.profile, child: ProfileFeature.init)
  }
}
