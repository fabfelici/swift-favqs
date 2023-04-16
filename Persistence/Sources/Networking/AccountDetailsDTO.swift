import Foundation

import Domain

struct AccountDetailsDTO: Decodable {
  let email: String
  let privateFavoritesCount: Int
  let proExpiration: Date?
}

extension AccountDetails {
  init(_ dto: AccountDetailsDTO) {
    self.init(
      email: dto.email,
      privateFavoritesCount: dto.privateFavoritesCount,
      proExpiration: dto.proExpiration
    )
  }
}
