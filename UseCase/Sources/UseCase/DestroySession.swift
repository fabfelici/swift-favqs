import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func destroySession() async throws {
    @Dependency(\.sessionRepository) var sessionRepository
    try await sessionRepository.destroy()
  }

}
