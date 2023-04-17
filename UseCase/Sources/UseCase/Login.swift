import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func login(
    username: String,
    password: String
  ) async throws -> User {
    @Dependency(\.sessionRepository) var sessionRepository
    @Dependency(\.userRepository) var userRepository
    let session = try await sessionRepository.create(username, password)
    return try await userRepository.read(session.login, session)
  }

}
