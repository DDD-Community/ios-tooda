//
//  NoteDetailReactor.swift
//  Tooda
//
//  Created by Jinsu Park on 2022/01/01.
//

import Foundation

import ReactorKit
import RxSwift

final class NoteDetailReactor: Reactor {

  // MARK: Dependency

  struct Dependency {

  }


  // MARK: Reactor

  enum Action {

  }

  enum Mutation {

  }

  struct State {

  }


  // MARK: Properties

  private let dependency: Dependency

  let initialState: State = State()

  init(dependency: Dependency) {
    self.dependency = dependency
  }
}


// MARK: - Mutate

extension NoteDetailReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    return .empty()
  }
}


// MARK: - Reduce

extension NoteDetailReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    return newState
  }
}
