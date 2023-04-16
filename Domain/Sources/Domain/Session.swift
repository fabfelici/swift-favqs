import Foundation

public struct Session: Equatable {

  public let userToken: String
  public let login: String
  public let userName: String

  public init(
    userToken: String,
    login: String,
    userName: String
  ) {
    self.userToken = userToken
    self.login = login
    self.userName = userName
  }
}

#if DEBUG
public extension Session {
  static let mock = Self(
    userToken: "1212",
    login: "sean_price",
    userName: "sp.ruck@bootcamp.com"
  )
}
#endif
