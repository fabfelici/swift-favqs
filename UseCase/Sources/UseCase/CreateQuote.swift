import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func createQuote(author: String, body: String) async throws -> Quote {
    @Dependency(\.quoteRepository) var quoteRepository
    return try await quoteRepository.create(author, body)
  }

}
