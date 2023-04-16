import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func quotes(parameters: QuotesParameters?) async throws -> QuotePage {
    @Dependency(\.quoteRepository) var quoteRepository
    @Dependency(\.sessionRepository) var sessionRepository
    let session = try? await sessionRepository.read()
    return try await quoteRepository.quotes(parameters, session)
  }

}
