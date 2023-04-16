import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func unhideQuote(id: Int) async throws -> Quote {
    @Dependency(\.sessionRepository) var sessionRepository
    @Dependency(\.quoteRepository) var quoteRepository
    return try await quoteRepository.update(id, .unhide, sessionRepository.read())
  }

}
