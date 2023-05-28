import SwiftUI

import ComposableArchitecture

import Domain
import Feature

struct CreateQuoteView: View {

  let store: StoreOf<CreateQuoteFeature>

  init(store: StoreOf<CreateQuoteFeature>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        Form {
          Section(
            content: {
              TextField(
                "",
                text: viewStore.binding(
                  get: \.author,
                  send: CreateQuoteFeature.Action.authorText
                )
              )
            },
            header: {
              Text("Author")
            }
          )

          Section(
            content: {
              TextEditor(
                text: viewStore.binding(
                  get: \.body,
                  send: CreateQuoteFeature.Action.bodyText
                )
              )
            },
            header: {
              Text("Body")
            }
          )
        }
        .navigationTitle("Create Quote")
        .toolbar {
          Button("Save") {
            viewStore.send(.save)
          }
          .disabled(!viewStore.isSaveEnabled)
        }
      }
    }
  }
}
