import Foundation

public struct User: Equatable {

  public let login: String
  public let picUrl: URL
  public let publicFavoritesCount: Int
  public let followers: Int
  public let following: Int
  public let pro: Bool
  public let accountDetails: AccountDetails?

  public init(
    login: String,
    picUrl: URL,
    publicFavoritesCount: Int,
    followers: Int,
    following: Int,
    pro: Bool,
    accountDetails: AccountDetails? = nil
  ) {
    self.login = login
    self.picUrl = picUrl
    self.publicFavoritesCount = publicFavoritesCount
    self.followers = followers
    self.following = following
    self.pro = pro
    self.accountDetails = accountDetails
  }

}

#if DEBUG
public extension User {
  static let mock = Self(
    login: "gose",
    picUrl: .init(string: "https://pbs.twimg.com/profile_images/2160924471/Screen_Shot_2012-04-23_at_9.23.44_PM_.png")!,
    publicFavoritesCount: 520,
    followers: 12,
    following: 23,
    pro: true,
    accountDetails: .mock
  )
}
#endif
