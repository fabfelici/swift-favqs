import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func logout() async throws {
    @Dependency(\.sessionRepository) var sessionRepository
    try await sessionRepository.destroy()
  }

}
