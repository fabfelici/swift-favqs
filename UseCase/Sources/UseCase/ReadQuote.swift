import Foundation

import Dependencies

import Domain

public extension UseCases {

  static func readQuote(id: Int) async throws -> Quote {
    @Dependency(\.sessionRepository) var sessionRepository
    @Dependency(\.quoteRepository) var quoteRepository
    let session = try? await sessionRepository.read()
    return try await quoteRepository.read(id, session)
  }

}
