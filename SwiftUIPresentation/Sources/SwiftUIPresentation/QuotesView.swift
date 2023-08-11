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
      ZStack(alignment: .top) {
        List(viewStore.quotes, id: \.id) { value in
          QuoteView(
            quote: value,
            update: { type in
              viewStore.send(.update(value.id, type))
            }
          )
          .onAppear {
            if value.id == viewStore.quotes.last?.id {
              viewStore.send(.loadNext)
            }
          }
        }
        .onAppear {
          if viewStore.quotes.isEmpty {
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
        .navigationTitle("Quotes")
        .sheet(
          isPresented: viewStore.binding(
            get: { $0.createQuoteState != nil },
            send: { $0 ? .presentCreateQuote : .dismissCreateQuote }
          )
        ) {
          IfLetStore(
            self.store.scope(state: \.createQuoteState, action: QuotesFeature.Action.createQuote),
            then: CreateQuoteView.init
          )
        }

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
