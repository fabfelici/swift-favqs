import Foundation

import Domain

struct UpdateUserRequestDTO: Encodable {
  let user: User

  struct User: Encodable {
    let login: String?
    let email: String?
    let password: String?
    let twitterUsername: String?
    let facebookUsername: String?
    let pic: String?
    let profanityFilter: Bool?
  }

}

extension UpdateUserRequestDTO {
  init(_ domain: UpdateUserParameters) {
    self.init(
      user: .init(
        login: domain.login,
        email: domain.email,
        password: domain.password,
        twitterUsername: domain.twitterUsername,
        facebookUsername: domain.facebookUsername,
        pic: domain.pic,
        profanityFilter: domain.profanityFilter
      )
    )
  }
}
