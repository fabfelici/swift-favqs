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

  public var quotes: (_ parameters: QuotesParameters?) async throws -> QuotePage

  public var read: (_ id: Int) async throws -> Quote

  public var update: (_ id: Int, _ updateType: UpdateQuoteType) async throws -> Quote

  public var create: (_ author: String, _ body: String) async throws -> Quote

  public init(
    quotes: @escaping (QuotesParameters?) async throws -> QuotePage,
    read: @escaping (Int) async throws -> Quote,
    update: @escaping (Int, UpdateQuoteType) async throws -> Quote,
    create: @escaping (String, String) async throws -> Quote
  ) {
    self.quotes = quotes
    self.read = read
    self.update = update
    self.create = create
  }

}

#if DEBUG
public extension QuoteRepository {
  static let mock = Self(
    quotes: { _ in
      .mock
    },
    read: { _ in
      .mock
    },
    update: { _, _ in
      .mock
    },
    create: { _, _ in
      .mock
    }
  )
}
#endif
