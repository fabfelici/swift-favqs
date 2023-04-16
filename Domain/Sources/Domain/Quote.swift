import Foundation

public struct Quote: Equatable {

  public let id: Int
  public let body: String
  public let favoritesCount: Int
  public let upvotesCount: Int
  public let downvotesCount: Int
  public let authorName: String
  public let userDetails: UserDetails?

  public init(
    id: Int,
    body: String,
    favoritesCount: Int,
    upvotesCount: Int,
    downvotesCount: Int,
    authorName: String,
    userDetails: UserDetails?
  ) {
    self.id = id
    self.body = body
    self.favoritesCount = favoritesCount
    self.upvotesCount = upvotesCount
    self.downvotesCount = downvotesCount
    self.authorName = authorName
    self.userDetails = userDetails
  }

}

#if DEBUG
public extension Quote {
  static let mock = Self(
    id: 1,
    body: "Shawn Carter is nice but Sean Price is the best",
    favoritesCount: 100,
    upvotesCount: 100,
    downvotesCount: 0,
    authorName: "Sean Price",
    userDetails: .init(
      favorite: true,
      upvote: true,
      downvote: false,
      hidden: false
    )
  )
}
#endif
