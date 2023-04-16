import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func readSession() async throws -> Session {
    @Dependency(\.sessionRepository) var sessionRepository
    return try await sessionRepository.read()
  }

}
