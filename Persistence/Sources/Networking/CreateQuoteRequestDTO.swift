import Foundation

struct CreateQuoteRequestDTO: Encodable {
  let quote: CreateQuoteDTO
}

struct CreateQuoteDTO: Encodable {
  let author: String
  let body: String
}
