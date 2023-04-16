import Foundation

import Domain

public extension SessionRepository {
  static let live: SessionRepository = {
    let helper = KeychainHelper(service: "session", account: "favqs")
    return .init(
      create: { username, password in
        let dto = try await URLSession.shared.createSession(username: username, password: password)
        try? helper.destroy()
        try helper.save(dto)
        return .init(dto)
      },
      read: {
        .init(try helper.read())
      },
      update: { session in
        let dto = SessionDTO(userToken: session.userToken, login: session.login, email: session.userName)
        try? helper.destroy()
        try helper.save(dto)
      },
      destroy: {
        _ = try await URLSession.shared.destroySession(session: .init(helper.read()))
        try helper.destroy()
      }
    )
  }()
}

private final class KeychainHelper {

  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let service: String
  private let account: String

  init(
    service: String,
    account: String
  ) {
    self.service = service
    self.account = account
  }

  func save<T: Encodable>(_ object: T) throws {
    let data = try encoder.encode(object)
    let query = [
      kSecAttrService: self.service,
      kSecAttrAccount: self.account,
      kSecClass: kSecClassGenericPassword,
      kSecValueData: data
    ] as [CFString : Any] as CFDictionary

    let status = SecItemAdd(query, nil)

    if status != errSecSuccess {
      throw RepositoryError(message: "Save keychain error", errorCode: .userSessionNotFound)
    }
  }

  func destroy() throws {
    let query = [
      kSecAttrService: self.service,
      kSecAttrAccount: self.account,
      kSecClass: kSecClassGenericPassword,
    ] as [CFString : Any] as CFDictionary

    let status = SecItemDelete(query)

    if status != errSecSuccess {
      throw RepositoryError(message: "Delete keychain error", errorCode: .userSessionNotFound)
    }
  }

  func read<T: Decodable>() throws -> T {
    let query = [
      kSecAttrService: self.service,
      kSecAttrAccount: self.account,
      kSecClass: kSecClassGenericPassword,
      kSecReturnData: true
    ] as [CFString : Any] as CFDictionary

    var result: AnyObject?
    let status = SecItemCopyMatching(query, &result)
    guard status == errSecSuccess, let decoded = try (result as? Data).flatMap({
      try decoder.decode(T.self, from: $0)
    }) else {
      throw RepositoryError(message: "Read keychain error", errorCode: .userSessionNotFound)
    }
    return decoded
  }
}
