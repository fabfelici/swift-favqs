import Foundation

import Dependencies

import Domain

public enum SessionRepositoryKey: TestDependencyKey {
  public static var testValue: SessionRepository = {
#if DEBUG
    .mock
#else
    fatalError()
#endif
  }()
}

public extension DependencyValues {
  var sessionRepository: SessionRepository {
    get { self[SessionRepositoryKey.self] }
    set { self[SessionRepositoryKey.self] = newValue }
  }
}

public enum QuoteRepositoryKey: TestDependencyKey {
  public static var testValue: QuoteRepository = {
#if DEBUG
    .mock
#else
    fatalError()
#endif
  }()
}

public extension DependencyValues {
  var quoteRepository: QuoteRepository {
    get { self[QuoteRepositoryKey.self] }
    set { self[QuoteRepositoryKey.self] = newValue }
  }
}

public enum UserRepositoryKey: TestDependencyKey {
  public static var testValue: UserRepository = {
#if DEBUG
    .mock
#else
    fatalError()
#endif
  }()
}

public extension DependencyValues {
  var userRepository: UserRepository {
    get { self[UserRepositoryKey.self] }
    set { self[UserRepositoryKey.self] = newValue }
  }
}
