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
      NavigationView {
        ZStack(alignment: .top) {
          let quotes = viewStore.quotes
          List(Array(quotes.enumerated()), id: \.element.id) { value in
            QuoteView(
              quote: value.element,
              update: { type in
                viewStore.send(.update(value.element.id, type))
              }
            )
            .onAppear {
              if value.offset == quotes.count - 1 {
                viewStore.send(.loadNext)
              }
            }
          }
          .navigationTitle("Quotes")
          .onAppear {
            if quotes.isEmpty {
              viewStore.send(.start)
            }
          }
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
          .searchable(
            text: viewStore.binding(
              get: { $0.searchText },
              send: QuotesFeature.Action.searchText
            )
          )

          if viewStore.status == .failed {
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
