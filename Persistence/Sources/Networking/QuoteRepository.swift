import Foundation

import Domain

public extension QuoteRepository {

  static let live = Self(
    quotes: { params, session in
      let dto = try await URLSession.shared.readQuotes(parameters: params, session: session)
      return .init(dto)
    },
    read: { id, session in
      let dto = try await URLSession.shared.readQuote(id: id, session: session)
      return .init(dto)
    },
    update: { id, updateType, session in
      let dto = try await URLSession.shared.updateQuote(id: id, updateType: updateType, session: session)
      return .init(dto)
    }
  )

}
