import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func upvoteQuote(id: Int) async throws -> Quote {
    @Dependency(\.sessionRepository) var sessionRepository
    @Dependency(\.quoteRepository) var quoteRepository
    return try await quoteRepository.update(id, .upvote, sessionRepository.read())
  }

}
