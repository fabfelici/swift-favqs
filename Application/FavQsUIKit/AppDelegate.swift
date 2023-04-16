import UIKit

import UIKitPresentation
import Domain
import Networking

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow()
    window.rootViewController = AppViewController(
      quoteRepository: .live,
      sessionRepository: .live
    )
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}

