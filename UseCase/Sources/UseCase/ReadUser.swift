import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func readUser(login: String) async throws -> User {
    @Dependency(\.userRepository) var userRepository
    @Dependency(\.sessionRepository) var sessionRepository
    return try await userRepository.read(login, sessionRepository.read())
  }

}
