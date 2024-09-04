import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func readQuote(id: Int) async throws -> Quote {
    @Dependency(\.quoteRepository) var quoteRepository
    return try await quoteRepository.read(id)
  }

}
