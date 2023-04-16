import Foundation

public struct QuoteRepository {

  public enum UpdateQuoteType: Equatable {
    case fav
    case unfav
    case upvote
    case downvote
    case clearvote
    case tag([String])
    case hide
    case unhide
  }

  public var quotes: (_ parameters: QuotesParameters?, _ session: Session?) async throws -> QuotePage

  public var read: (_ id: Int, _ session: Session?) async throws -> Quote

  public var update: (_ id: Int, _ updateType: UpdateQuoteType, _ session: Session) async throws -> Quote

  public init(
    quotes: @escaping (QuotesParameters?, Session?) async throws -> QuotePage,
    read: @escaping (Int, Session?) async throws -> Quote,
    update: @escaping (_ id: Int, _ updateType: UpdateQuoteType, _ session: Session) async throws -> Quote
  ) {
    self.quotes = quotes
    self.read = read
    self.update = update
  }

}

#if DEBUG
public extension QuoteRepository {
  static let mock = Self(
    quotes: { _, _ in
      .mock
    },
    read: { _, _ in
      .mock
    },
    update: { _, _, _ in
      .mock
    }
  )
}
#endif
