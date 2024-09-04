import Foundation

import Dependencies

import Domain

extension SessionRepository: TestDependencyKey {
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
    get { self[SessionRepository.self] }
    set { self[SessionRepository.self] = newValue }
  }
}

extension QuoteRepository: TestDependencyKey {
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
    get { self[QuoteRepository.self] }
    set { self[QuoteRepository.self] = newValue }
  }
}

extension UserRepository: TestDependencyKey {
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
    get { self[UserRepository.self] }
    set { self[UserRepository.self] = newValue }
  }
}
