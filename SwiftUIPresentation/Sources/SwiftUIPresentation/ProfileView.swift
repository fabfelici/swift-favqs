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
        CaseLet(
          state: /ProfileFeature.State.login,
          action: ProfileFeature.Action.login,
          then: MainLoginView.init
        )
        CaseLet(
          state: /ProfileFeature.State.profile,
          then: ProfileView.init
        )
      }
      .navigationTitle("Profile")
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
        Section(
          content: {
            Text("Favorites: \(viewStore.publicFavoritesCount)")
            Text("Followers: \(viewStore.followers)")
            Text("Following: \(viewStore.following)")
          },
          header: {
            HStack {
              AsyncImage(url: viewStore.picUrl) { image in
                image.resizable()
                  .scaledToFit()
              } placeholder: {
                Image(systemName: "person")
              }
              .frame(width: 40, height: 40)
              .clipShape(Circle())

              Text("FAVQS")
            }
          }
        )

        Section(
          content: {
            Text("Email: \(viewStore.accountDetails?.email ?? "")")
            Text("Username: \(viewStore.login)")
            Button("Log Out", role: .destructive) {
              viewStore.send(.logout)
            }
          },
          header: {
            Text("ACCOUNT")
          }
        )
      }
      .refreshable {
        viewStore.send(.refresh)
      }
      .onAppear {
        viewStore.send(.refresh)
      }
    }
  }
}
