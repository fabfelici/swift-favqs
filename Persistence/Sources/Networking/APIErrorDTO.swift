import Foundation

import Domain

struct APIErrorDTO: Error, Decodable {
  enum ErrorCode: Int, Decodable {
    case invalidRequest = 10
    case permissionDenied = 11
    case userSessionNotFound = 20
    case invalidLoginOrPassword = 21
    case loginIsNotActive = 22
    case userLoginOrPasswordIsMissing = 23
    case proUserRequire = 24
    case userNotFound = 30
    case userSessionAlreadyPresent = 31
    case listOfUserValidationErrors = 32
    case invalidPasswordResetToken = 33
    case quoteNotFound = 40
    case privateQuotesCannotBeUnfavored = 41
    case couldNotCreateQuote = 42
    case authorNotFound = 50
    case tagNotFound = 60
    case activityNotFound = 70
    case invalidResponse = 100
  }

  let message: String
  let errorCode: ErrorCode
}

extension RepositoryError {
  init(_ dto: APIErrorDTO) {
    self.init(
      message: dto.message,
      errorCode: .init(dto.errorCode)
    )
  }
}

extension RepositoryError.ErrorCode {
  init(_ dto: APIErrorDTO.ErrorCode) {
    switch dto {
    case .invalidRequest:
      self = .invalidRequest
    case .permissionDenied:
      self = .permissionDenied
    case .userSessionNotFound:
      self = .userSessionNotFound
    case .invalidLoginOrPassword:
      self = .invalidLoginOrPassword
    case .loginIsNotActive:
      self = .loginIsNotActive
    case .userLoginOrPasswordIsMissing:
      self = .userLoginOrPasswordIsMissing
    case .proUserRequire:
      self = .proUserRequire
    case .userNotFound:
      self = .userNotFound
    case .userSessionAlreadyPresent:
      self = .userSessionAlreadyPresent
    case .listOfUserValidationErrors:
      self = .listOfUserValidationErrors
    case .invalidPasswordResetToken:
      self = .invalidPasswordResetToken
    case .quoteNotFound:
      self = .quoteNotFound
    case .privateQuotesCannotBeUnfavored:
      self = .privateQuotesCannotBeUnfavored
    case .couldNotCreateQuote:
      self = .couldNotCreateQuote
    case .authorNotFound:
      self = .authorNotFound
    case .tagNotFound:
      self = .tagNotFound
    case .activityNotFound:
      self = .activityNotFound
    case .invalidResponse:
      self = .invalidResponse
    }
  }
}
