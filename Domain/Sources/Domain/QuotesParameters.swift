import Foundation

public struct QuotesParameters {

  public let filter: String?
  public let type: QuoteType?
  public let isPrivate: Bool?
  public let hidden: Bool?
  public let page: Int?

  public init(
    filter: String? = nil,
    type: QuoteType? = nil,
    isPrivate: Bool? = nil,
    hidden: Bool? = nil,
    page: Int? = nil
  ) {
    self.filter = filter
    self.type = type
    self.isPrivate = isPrivate
    self.hidden = hidden
    self.page = page
  }

}

public enum QuoteType {
  case author
  case tag
  case user
}
