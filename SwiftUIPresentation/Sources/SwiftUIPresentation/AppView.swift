import SwiftUI

import ComposableArchitecture

import Feature

public struct AppView: View {

  let store: StoreOf<AppFeature>

  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      TabView {
        NavigationView {
          QuotesView(
            store: store.scope(
              state: \.quotes,
              action: AppFeature.Action.quotes
            )
          )
          .toolbar {
            if (/ProfileFeature.State.profile).extract(from: viewStore.state.profile) != nil {
              Button("Add Quote") {
                viewStore.send(.quotes(.presentCreateQuote))
              }
            }
          }
        }
        .tabItem {
          Label("Quotes", systemImage: "text.quote")
        }

        MainProfileView(
          store: store.scope(
            state: \.profile,
            action: AppFeature.Action.profile
          )
        )
        .tabItem {
          Label("Profile", systemImage: "person.fill")
        }
      }
      .onAppear {
        viewStore.send(.profile(.refresh))
      }
    }
  }
}
