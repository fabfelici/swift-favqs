import Foundation

struct CreateUserRequestDTO: Encodable {

  let user: User

  struct User: Encodable {
    let login: String
    let email: String
    let password: String
  }
}
