import SwiftUI

import ComposableArchitecture

import Feature

struct QuotesView: View {

  let store: StoreOf<QuotesFeature>

  init(store: StoreOf<QuotesFeature>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      let quotes = viewStore.state.quotes
      NavigationView {
        ZStack(alignment: .top) {
          List(Array(quotes.enumerated()), id: \.offset) { value in
            QuoteView(
              quote: value.element,
              upvote: {
                viewStore.send(.upvote(value.element.id))
              },
              downvote: {
                viewStore.send(.downvote(value.element.id))
              },
              clearvote: {
                viewStore.send(.clearvote(value.element.id))
              },
              favorite: {
                viewStore.send(.favorite(value.element.id))
              },
              unfavorite: {
                viewStore.send(.unfavorite(value.element.id))
              }
            )
            .onAppear {
              if value.offset == quotes.count - 1 {
                viewStore.send(.loadNext)
              }
            }
          }
          .navigationTitle("Quotes")
          .refreshable {
            await viewStore.send(.start) {
              switch $0.status {
              case .loading:
                return true
              case .loaded, .failed:
                return false
              }
            }
          }
          if viewStore.state.status == .failed {
            Text("Connection Issues")
              .fontWeight(.medium)
              .font(.callout)
              .frame(
                maxWidth: .infinity,
                minHeight: 50,
                maxHeight: 50,
                alignment: .center
              )
              .background(.red)
          }
        }
      }
      .onAppear {
        if viewStore.quotes.isEmpty {
          viewStore.send(.start)
        }
      }
    }
  }
}

#if targetEnvironment(simulator) && DEBUG
@testable import Feature

struct QuotesView_Previews: PreviewProvider {
  static var previews: some View {
    QuotesView(
      store: .init(
        initialState: .init(),
        reducer: QuotesFeature()
      )
    )
  }
}
#endif
