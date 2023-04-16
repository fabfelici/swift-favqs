import Foundation

struct SessionRequestDTO: Encodable {

  let user: User

  struct User: Encodable {
    let login: String
    let password: String
  }
}
