import Foundation

import CasePaths

enum LoadingState<Value, Failure: Error> {

  case loading
  case loaded(Value)
  case failure(Failure)

  var value: Value? {
    let valuePath = /LoadingState<Value, Failure>.loaded
    return valuePath.extract(from: self)
  }
}

extension LoadingState: Equatable where Value: Equatable, Failure: Equatable { }
