import Foundation

import Domain

public extension UserRepository {

  static let live = Self(
    create: { login, email, password in
      let dto = try await URLSession.shared.createUser(login: login, email: email, password: password)
      return .init(dto)
    },
    read: { login, session in
      let dto = try await URLSession.shared.readUser(login: login, session: session)
      return .init(dto)
    },
    update: { login, parameters, session in
      _ = try await URLSession.shared.updateUser(login: login, parameters: parameters, session: session)
    }
  )

}
