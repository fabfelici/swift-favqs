import Foundation

public struct UserRepository {

  public var create: (_ login: String, _ email: String, _ password: String) async throws -> Session

  public var read: (_ login: String) async throws -> User

  public var update: (_ login: String, _ parameters: UpdateUserParameters) async throws -> Void

  public init(
    create: @escaping (String, String, String) async throws -> Session,
    read: @escaping (String) async throws -> User,
    update: @escaping (String, UpdateUserParameters) async throws -> Void
  ) {
    self.create = create
    self.read = read
    self.update = update
  }

}

#if DEBUG
public extension UserRepository {
  static let mock = Self(
    create: { _, _ , _ in
      .mock
    },
    read: { _ in
      .mock
    },
    update: { _, _ in
      return
    }
  )
}
#endif
