import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func clearVoteQuote(id: Int) async throws -> Quote {
    @Dependency(\.quoteRepository) var quoteRepository
    @Dependency(\.sessionRepository) var sessionRepository
    return try await quoteRepository.update(id, .clearvote, sessionRepository.read())
  }

}
