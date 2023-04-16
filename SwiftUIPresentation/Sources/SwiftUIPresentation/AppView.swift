import SwiftUI

import ComposableArchitecture

import Feature

public struct AppView: View {

  let store: StoreOf<AppFeature>

  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }

  public var body: some View {
    TabView {
      QuotesView(
        store: store.scope(state: \.quotes, action: AppFeature.Action.quotes)
      )
      .tabItem {
        Label("Quotes", systemImage: "text.quote")
      }

      MainProfileView(
        store: store.scope(state: \.profile, action: AppFeature.Action.profile)
      )
      .tabItem {
        Label("Profile", systemImage: "person.fill")
      }
    }
  }
}
