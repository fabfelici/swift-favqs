import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func createSession(
    username: String,
    password: String
  ) async throws -> Session {
    @Dependency(\.sessionRepository) var sessionRepository
    return try await sessionRepository.create(username, password)
  }

}
