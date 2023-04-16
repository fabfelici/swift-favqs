import Foundation

public struct UserDetails: Equatable {

  public let favorite: Bool
  public let upvote: Bool
  public let downvote: Bool
  public let hidden: Bool

  public init(favorite: Bool, upvote: Bool, downvote: Bool, hidden: Bool) {
    self.favorite = favorite
    self.upvote = upvote
    self.downvote = downvote
    self.hidden = hidden
  }

}
