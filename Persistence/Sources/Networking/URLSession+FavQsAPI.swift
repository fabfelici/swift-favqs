import Foundation

import ArkanaKeys
import Overture

import Domain

let baseURL = "https://favqs.com/api/"
let apiKey = Keys.Global().favQsApiKey

enum Endpoint: String {
  case quotes
  case session
  case fav
  case unfav
  case upvote
  case downvote
  case clearvote
  case hide
  case unhide
  case tag
  case users
}

extension URLSession {

  private func decoded<T: Decodable>(for request: URLRequest) async throws -> T {
    let response = try await data(for: request)
    guard let httpResponse = response.1 as? HTTPURLResponse else {
      throw RepositoryError(message: "Non HTTP Response", errorCode: .invalidResponse)
    }
    guard 200 ..< 305 ~= httpResponse.statusCode else {
      throw RepositoryError(message: "Invalid Response", errorCode: .invalidResponse)
    }
    let decoder = with(JSONDecoder(), set(\.keyDecodingStrategy, .convertFromSnakeCase))
    do {
      return try decoder.decode(T.self, from: response.0)
    } catch {
      throw RepositoryError(try decoder.decode(APIErrorDTO.self, from: response.0))
    }
  }

}

extension URLSession {

  func createSession(username: String, password: String) async throws -> SessionDTO {
    let urlString = baseURL + Endpoint.session.rawValue
    var request = try post(nil, urlString)
    request.httpBody = try JSONEncoder()
      .encode(
        SessionRequestDTO(
          user: .init(
            login: username,
            password: password
          )
        )
      )
    return try await decoded(for: request)
  }

  func destroySession(session: Session) async throws -> SessionDestroyDTO {
    let urlString = baseURL + Endpoint.session.rawValue
    let request = try delete(session, urlString)
    return try await decoded(for: request)
  }

}

extension URLSession {

  func readQuotes(parameters: QuotesParameters?, session: Session?) async throws -> QuotePageDTO {
    let urlString = baseURL + Endpoint.quotes.rawValue
    let urlStringWithQueryItems = try urlStringWithQueryItems(urlString, parameters?.toQueryItems)
    let request = try get(session, urlStringWithQueryItems)
    return try await decoded(for: request)
  }

  func readQuote(id: Int, session: Session?) async throws -> QuoteDTO {
    let urlString = baseURL + Endpoint.quotes.rawValue + "/\(id)"
    let request = try get(session, urlString)
    return try await decoded(for: request)
  }

  func updateQuote(
    id: Int,
    updateType: QuoteRepository.UpdateQuoteType,
    session: Session
  ) async throws -> QuoteDTO {
    let endpoint: Endpoint
    switch updateType {
    case .fav:
      endpoint = .fav
    case .unfav:
      endpoint = .unfav
    case .upvote:
      endpoint = .upvote
    case .downvote:
      endpoint = .downvote
    case .clearvote:
      endpoint = .clearvote
    case .hide:
      endpoint = .hide
    case .unhide:
      endpoint = .unhide
    case .tag:
      endpoint = .tag
    }
    let urlString = baseURL + Endpoint.quotes.rawValue + "/\(id)/" + endpoint.rawValue
    let request = try put(session, urlString)
    return try await decoded(for: request)
  }

}

extension URLSession {

  func createUser(login: String, email: String, password: String) async throws -> SessionDTO {
    let urlString = baseURL + Endpoint.users.rawValue
    var request = try post(nil, urlString)
    request.httpBody = try JSONEncoder()
      .encode(
        CreateUserRequestDTO(
          user: .init(
            login: login,
            email: email,
            password: password
          )
        )
      )
    return try await decoded(for: request)
  }

  func readUser(login: String, session: Session) async throws -> UserDTO {
    let urlString = baseURL + Endpoint.users.rawValue + "/\(login)"
    let request = try get(session, urlString)
    return try await decoded(for: request)
  }

  func updateUser(login: String, parameters: UpdateUserParameters, session: Session) async throws -> UpdateUserDTO {
    let urlString = baseURL + Endpoint.users.rawValue + "/\(login)"
    var request = try put(session, urlString)
    let encoder = with(JSONEncoder(), set(\.keyEncodingStrategy, .convertToSnakeCase))
    request.httpBody = try encoder.encode(UpdateUserRequestDTO(parameters))
    return try await decoded(for: request)
  }

}

let urlStringWithQueryItems: (String, [URLQueryItem]?) throws -> String = { urlString, queryItems in
  let urlStringWithQueryItems = chain(
    URLComponents.init(string:),
    set(\.queryItems, queryItems),
    Overture.get(\.string)
  )
  guard let urlString = urlStringWithQueryItems(urlString) else {
    throw RepositoryError(message: "Wrong URL", errorCode: .invalidRequest)
  }
  return urlString
}

let defaultRequest: (String) throws -> URLRequest = { urlString in
  guard let url = URL(string: urlString) else {
    throw RepositoryError(message: "Wrong URL", errorCode: .invalidRequest)
  }
  return .init(url: url)
}

let setHeader = { name, value in
  { (request: inout URLRequest) in
    request.setValue(value, forHTTPHeaderField: name)
  }
}

let authenticatedRequest = { (urlString: String, session: Session?) in
  update(
    try defaultRequest(urlString),
    setHeader("Authorization", "Token token=\(apiKey)"),
    setHeader("Content-Type", "application/json"),
    setHeader("User-Token", session?.userToken)
  )
}

let requestWithMethod = { method, session, urlString in
  update(
    try authenticatedRequest(urlString, session),
    mut(\.httpMethod, method)
  )
}

let get = uncurry(curry(requestWithMethod)("GET"))
let post = uncurry(curry(requestWithMethod)("POST"))
let delete = uncurry(curry(requestWithMethod)("DELETE"))
let put = uncurry(curry(requestWithMethod)("PUT"))

extension QuotesParameters {
  var toQueryItems: [URLQueryItem] {
    [
      .init(
        name: "page",
        value: page.map(String.init)
      ),
      filter.flatMap {
        guard !$0.isEmpty else {
          return nil
        }
        return .init(
          name: "filter",
          value: $0
        )
      }
    ]
    .compactMap { $0 }
  }
}
