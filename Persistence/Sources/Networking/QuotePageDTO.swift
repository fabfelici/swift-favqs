import Foundation

import Domain

struct QuotePageDTO: Decodable {
  let quotes: [QuoteDTO]
  let lastPage: Bool
}

extension QuotePage {
  init(_ dto: QuotePageDTO) {
    self.init(
      quotes: dto.quotes.map(Quote.init),
      lastPage: dto.lastPage || (dto.quotes.first?.id ?? 0) == 0
    )
  }
}
