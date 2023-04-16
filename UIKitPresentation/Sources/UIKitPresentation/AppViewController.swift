import UIKit

import Domain
import Feature

public final class AppViewController: UIViewController {

  private let quoteRepository: QuoteRepository
  private let sessionRepository: SessionRepository

  public init(
    quoteRepository: QuoteRepository,
    sessionRepository: SessionRepository
  ) {
    self.quoteRepository = quoteRepository
    self.sessionRepository = sessionRepository
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { nil }

  public override func viewDidLoad() {
    super.viewDidLoad()
  }

}
