import SwiftUI

import Dependencies

import Domain
import Networking
import UseCase
import Feature
import SwiftUIPresentation

extension QuoteRepository: DependencyKey {
  public static var liveValue: QuoteRepository = .live
}

extension UserRepository: DependencyKey {
  public static var liveValue: UserRepository = .live
}

extension SessionRepository: DependencyKey {
  public static var liveValue: SessionRepository = .live
}

@main
struct Application: App {
  var body: some Scene {
    WindowGroup {
      AppView(store: .init(initialState: .init(), reducer: AppFeature()._printChanges()))
    }
  }
}
