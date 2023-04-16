import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func updateUser(login: String, parameters: UpdateUserParameters) async throws {
    @Dependency(\.userRepository) var userRepository
    @Dependency(\.sessionRepository) var sessionRepository
    try await userRepository.update(login, parameters, sessionRepository.read())
  }

}
