import SwiftUI

import ComposableArchitecture

import Feature

struct MainLoginView: View {

  let store: StoreOf<LoginFeature>

  init(store: StoreOf<LoginFeature>) {
    self.store = store
  }

  var body: some View {
    SwitchStore(store) {
      CaseLet(state: /LoginFeature.State.login, then: LoginView.init)
      CaseLet(state: /LoginFeature.State.loggingIn, then: LoggingInView.init)
      Default {

      }
    }
  }
}

struct LoginView: View {

  let store: Store<LoginFeature.State.LoginState, LoginFeature.Action>

  init(store: Store<LoginFeature.State.LoginState, LoginFeature.Action>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      Form {
        Section(header: Text("ACCOUNT")) {
          TextField(
            "Username",
            text: viewStore.binding(
              get: \.userName,
              send: LoginFeature.Action.userNameText
            )
          )
          #if os(iOS)
          .autocapitalization(.none)
          .keyboardType(.emailAddress)
          #endif
          .disableAutocorrection(true)
          .textContentType(.username)

          SecureField(
            "Password",
            text: viewStore.binding(
              get: \.password,
              send: LoginFeature.Action.passwordText
            )
          )
          .textContentType(.password)

          Button("Log In") {
            viewStore.send(.logIn)
          }
        }
      }
      .onAppear {
        viewStore.send(.start)
      }
    }
  }
}

struct LoggingInView: View {

  let store: Store<Void, LoginFeature.Action>

  init(store: Store<Void, LoginFeature.Action>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store) { viewStore in
      Form {
        Section(header: Text("ACCOUNT")) {
          Text("Logging In..")
        }
      }
    }
  }
}
