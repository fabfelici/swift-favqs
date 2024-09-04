import Foundation

import Domain

public extension UserRepository {

  static func live(sessionRepository: SessionRepository) -> Self {
    .init(
      create: { login, email, password in
        let dto = try await URLSession.shared.createUser(login: login, email: email, password: password)
        return .init(dto)
      },
      read: { login in
        let session = try await sessionRepository.read()
        let dto = try await URLSession.shared.readUser(login: login, session: session)
        return .init(dto)
      },
      update: { login, parameters in
        let session = try await sessionRepository.read()
        _ = try await URLSession.shared.updateUser(login: login, parameters: parameters, session: session)
      }
    )
  }

}
