import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func quotes(parameters: QuotesParameters?) async throws -> QuotePage {
    @Dependency(\.quoteRepository) var quoteRepository
    return try await quoteRepository.quotes(parameters)
  }

}
