import Foundation

public struct QuotePage: Equatable {

  public let quotes: [Quote]
  public let lastPage: Bool

  public init(quotes: [Quote], lastPage: Bool) {
    self.quotes = quotes
    self.lastPage = lastPage
  }
}

#if DEBUG
public extension QuotePage {
  static let mock = Self(
    quotes: [.mock],
    lastPage: true
  )
}
#endif
