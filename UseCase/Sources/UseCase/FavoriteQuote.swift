import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func favoriteQuote(id: Int) async throws -> Quote {
    @Dependency(\.sessionRepository) var sessionRepository
    @Dependency(\.quoteRepository) var quoteRepository
    return try await quoteRepository.update(id, .fav, sessionRepository.read())
  }

}
