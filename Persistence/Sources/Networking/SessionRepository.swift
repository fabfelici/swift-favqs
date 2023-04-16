import Foundation

import Domain

public extension SessionRepository {
  static let live = Self(
    create: { username, password in
      let dto = try await URLSession.shared.createSession(username: username, password: password)
      try KeychainHelper.shared.save(dto, service: "session", account: "favqs")
      return .init(dto)
    },
    read: {
      .init(try KeychainHelper.shared.read(service: "session", account: "favqs"))
    },
    update: { session in
      let dto = SessionDTO(userToken: session.userToken, login: session.login, email: session.userName)
      try KeychainHelper.shared.save(dto, service: "session", account: "favqs")
    },
    destroy: {
      let dto: SessionDTO = try KeychainHelper.shared.read(service: "session", account: "favqs")
      _ = try await URLSession.shared.destroySession(session: .init(dto))
      try KeychainHelper.shared.destroy(service: "session", account: "favqs")
    }
  )
}

private final class KeychainHelper {

  static let shared = KeychainHelper()
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  private init() { }

  func save<T: Encodable>(_ object: T, service: String, account: String) throws {
    let data = try encoder.encode(object)
    let query = [
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecClass: kSecClassGenericPassword,
      kSecValueData: data
    ] as [CFString : Any] as CFDictionary

    let status = SecItemAdd(query, nil)

    if status != errSecSuccess {
      throw RepositoryError(message: "Save keychain error", errorCode: .userSessionNotFound)
    }
  }

  func destroy(service: String, account: String) throws {
    let query = [
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecClass: kSecClassGenericPassword,
    ] as [CFString : Any] as CFDictionary

    let status = SecItemDelete(query)

    if status != errSecSuccess {
      throw RepositoryError(message: "Delete keychain error", errorCode: .userSessionNotFound)
    }
  }

  func read<T: Decodable>(service: String, account: String) throws -> T {
    let query = [
      kSecAttrService: service,
      kSecAttrAccount: account,
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
