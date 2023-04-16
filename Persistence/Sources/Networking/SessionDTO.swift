import Foundation

import Domain

struct SessionDTO: Codable {
  let userToken: String
  let login: String
  let email: String

  enum CodingKeys: String, CodingKey {
    case userToken = "User-Token"
    case login
    case email
  }
}

extension Session {
  init(_ dto: SessionDTO) {
    self.init(
      userToken: dto.userToken,
      login: dto.login,
      userName: dto.email
    )
  }
}

