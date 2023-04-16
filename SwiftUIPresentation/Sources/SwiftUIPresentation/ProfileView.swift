import SwiftUI

import ComposableArchitecture

import Domain
import Feature

struct MainProfileView: View {

  let store: StoreOf<ProfileFeature>

  init(store: StoreOf<ProfileFeature>) {
    self.store = store
  }

  var body: some View {
    NavigationView {
      SwitchStore(store) {
        CaseLet(state: /ProfileFeature.State.login, action: ProfileFeature.Action.login, then: MainLoginView.init)
        CaseLet(state: /ProfileFeature.State.profile, then: ProfileView.init)
      }
    }
  }
}

struct ProfileView: View {

  let store: Store<User, ProfileFeature.Action>

  init(store: Store<User, ProfileFeature.Action>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      Form {
        Section(header: Text("FAVQS")) {
          Text("Favorites: \(viewStore.state.publicFavoritesCount)")
          Text("Followers: \(viewStore.state.followers)")
          Text("Following: \(viewStore.state.following)")
        }
        Section(header: Text("ACCOUNT")) {
          Text("Email: \(viewStore.state.accountDetails?.email ?? "")")
          Text("Username: \(viewStore.state.login)")
          Button("Log Out", role: .destructive) {
            viewStore.send(.login(.logOut))
          }
        }
      }
      .navigationTitle("Profile")
      .refreshable {
        viewStore.send(.refresh)
      }
      .onAppear {
        viewStore.send(.refresh)
      }
    }
  }
}
