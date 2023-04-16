import Foundation

public struct RepositoryError: Error, Equatable {

  public enum ErrorCode {
    case invalidRequest
    case invalidResponse
    case permissionDenied
    case userSessionNotFound
    case invalidLoginOrPassword
    case loginIsNotActive
    case userLoginOrPasswordIsMissing
    case proUserRequire
    case userNotFound
    case userSessionAlreadyPresent
    case listOfUserValidationErrors
    case invalidPasswordResetToken
    case quoteNotFound
    case privateQuotesCannotBeUnfavored
    case couldNotCreateQuote
    case authorNotFound
    case tagNotFound
    case activityNotFound
  }

  public let message: String
  public let errorCode: ErrorCode

  public init(
    message: String,
    errorCode: ErrorCode
  ) {
    self.message = message
    self.errorCode = errorCode
  }
}
