import SwiftUI

import Dependencies

import Domain
import Networking
import UseCase
import Feature
import SwiftUIPresentation

extension QuoteRepository: DependencyKey {
  public static var liveValue: QuoteRepository = .live(sessionRepository: .live)
}

  public static var liveValue: SessionRepository = .live
}

extension UserRepository: DependencyKey {
  public static var liveValue: UserRepository = .live(sessionRepository: .live)
}

@main
struct Application: App {
  var body: some Scene {
    WindowGroup {
      AppView(store: .init(initialState: .init(), reducer: AppFeature()._printChanges()))
    }
  }
}
