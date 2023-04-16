import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func createUser(
    login: String,
    email: String,
    password: String
  ) async throws {
    @Dependency(\.userRepository) var userRepository
    @Dependency(\.sessionRepository) var sessionRepository
    try await sessionRepository.update(userRepository.create(login, email, password))
  }

}
