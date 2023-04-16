import Foundation

import Domain

struct QuoteDTO: Decodable {
  let id: Int
  let favoritesCount: Int
  let upvotesCount: Int
  let downvotesCount: Int
  let body: String?
  let author: String?
  let userDetails: UserDetailsDTO?
}

extension Quote {
  init(_ dto: QuoteDTO) {
    self.init(
      id: dto.id,
      body: dto.body ?? "",
      favoritesCount: dto.favoritesCount,
      upvotesCount: dto.favoritesCount,
      downvotesCount: dto.downvotesCount,
      authorName: dto.author ?? "",
      userDetails: dto.userDetails.map(UserDetails.init)
    )
  }
}
