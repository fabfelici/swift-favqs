import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func readUser(login: String) async throws -> User {
    @Dependency(\.userRepository) var userRepository
    @Dependency(\.sessionRepository) var sessionRepository
    let session = try await sessionRepository.read()
    return try await userRepository.read(login, session)
  }

}
