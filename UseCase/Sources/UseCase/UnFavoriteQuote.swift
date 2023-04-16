import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func unFavoriteQuote(id: Int) async throws -> Quote {
    @Dependency(\.sessionRepository) var sessionRepository
    @Dependency(\.quoteRepository) var quoteRepository
    return try await quoteRepository.update(id, .unfav, sessionRepository.read())
  }

}
