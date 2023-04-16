import Foundation

import Domain

struct UserDTO: Decodable {
  let login: String
  let picUrl: URL
  let publicFavoritesCount: Int
  let followers: Int
  let following: Int
  let pro: Bool?
  let accountDetails: AccountDetailsDTO?
}

extension User {
  init(_ dto: UserDTO) {
    self.init(
      login: dto.login,
      picUrl: dto.picUrl,
      publicFavoritesCount: dto.publicFavoritesCount,
      followers: dto.followers,
      following: dto.following,
      pro: dto.pro ?? false,
      accountDetails: dto.accountDetails.map(AccountDetails.init)
    )
  }
}
