import Foundation

public struct SessionRepository {

  public var create: (_ username: String, _ password: String) async throws -> Session

  public var read: () async throws -> Session

  public var update: (_ session: Session) async throws -> Void

  public var destroy: () async throws -> Void

  public init(
    create: @escaping (String, String) async throws -> Session,
    read: @escaping () async throws -> Session,
    update: @escaping (_ session: Session) async throws -> Void,
    destroy: @escaping () async throws -> Void
  ) {
    self.create = create
    self.read = read
    self.update = update
    self.destroy = destroy
  }

}

#if DEBUG
public extension SessionRepository {
  static let mock = Self(
    create: { _, _ in
      .mock
    },
    read: {
      .mock
    },
    update: { _ in
      return
    },
    destroy: {
      return
    }
  )
}
#endif
