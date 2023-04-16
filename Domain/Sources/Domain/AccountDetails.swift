import Foundation

public struct AccountDetails: Equatable {

  public let email: String
  public let privateFavoritesCount: Int
  public let proExpiration: Date?

  public init(
    email: String,
    privateFavoritesCount: Int,
    proExpiration: Date?
  ) {
    self.email = email
    self.privateFavoritesCount = privateFavoritesCount
    self.proExpiration = proExpiration
  }

}

#if DEBUG
public extension AccountDetails {
  static let mock = AccountDetails(
    email: "gose@favqs.com",
    privateFavoritesCount: 22,
    proExpiration: .distantFuture
  )
}
#endif
