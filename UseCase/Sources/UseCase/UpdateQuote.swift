import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func updateQuote(id: Int, type: QuoteRepository.UpdateQuoteType) async throws -> Quote {
    @Dependency(\.sessionRepository) var sessionRepository
    @Dependency(\.quoteRepository) var quoteRepository
    return try await quoteRepository.update(id, type, sessionRepository.read())
  }

}
