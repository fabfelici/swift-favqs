import Foundation

import Domain

struct UserDetailsDTO: Decodable {
  let favorite: Bool
  let upvote: Bool
  let downvote: Bool
  let hidden: Bool
}

extension UserDetails {
  init(_ dto: UserDetailsDTO) {
    self.init(
      favorite: dto.favorite,
      upvote: dto.upvote,
      downvote: dto.downvote,
      hidden: dto.hidden
    )
  }
}
