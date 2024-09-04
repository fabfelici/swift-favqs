import Foundation

import Domain

public extension QuoteRepository {

  static func live(sessionRepository: SessionRepository) -> Self {
    .init(
      quotes: { params in
        let session = try? await sessionRepository.read()
        let dto = try await URLSession.shared.readQuotes(parameters: params, session: session)
        return .init(dto)
      },
      read: { id in
        let session = try? await sessionRepository.read()
        let dto = try await URLSession.shared.readQuote(id: id, session: session)
        return .init(dto)
      },
      update: { id, updateType in
        let session = try await sessionRepository.read()
        let dto = try await URLSession.shared.updateQuote(id: id, updateType: updateType, session: session)
        return .init(dto)
      },
      create: { author, body in
        let session = try await sessionRepository.read()
        let dto = try await URLSession.shared.createQuote(author: author, body: body, session: session)
        return .init(dto)
      }
    )
  }

}
