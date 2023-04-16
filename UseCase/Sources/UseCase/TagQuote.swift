import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func tagQuote(id: Int, tags: [String]) async throws -> Quote {
    @Dependency(\.sessionRepository) var sessionRepository
    @Dependency(\.quoteRepository) var quoteRepository
    return try await quoteRepository.update(id, .tag(tags), sessionRepository.read())
  }

}
