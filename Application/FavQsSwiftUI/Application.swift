import SwiftUI

import Dependencies

import Domain
import Networking
import UseCase
import Feature
import SwiftUIPresentation

extension QuoteRepositoryKey: DependencyKey {
  public static var liveValue: QuoteRepository = .live
}

extension SessionRepositoryKey: DependencyKey {
  public static var liveValue: SessionRepository = .live
}

extension UserRepositoryKey: DependencyKey {
  public static var liveValue: UserRepository = .live
}

@main
struct Application: App {
  var body: some Scene {
    WindowGroup {
      AppView(store: .init(initialState: .init(), reducer: AppFeature()._printChanges()))
    }
  }
}
