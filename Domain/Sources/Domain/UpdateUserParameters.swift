import Foundation

public struct UpdateUserParameters {

  public let login: String?
  public let email: String?
  public let password: String?
  public let twitterUsername: String?
  public let facebookUsername: String?
  public let pic: String?
  public let profanityFilter: Bool?

  public init(
    login: String? = nil,
    email: String? = nil,
    password: String? = nil,
    twitterUsername: String? = nil,
    facebookUsername: String? = nil,
    pic: String? = nil,
    profanityFilter: Bool? = nil
  ) {
    self.login = login
    self.email = email
    self.password = password
    self.twitterUsername = twitterUsername
    self.facebookUsername = facebookUsername
    self.pic = pic
    self.profanityFilter = profanityFilter
  }

}
