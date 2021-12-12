//
//  SearchResultReactor.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/12/12.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class SearchResultReactor: Reactor {

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

extension SearchResultReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    return .empty()
  }
}


// MARK: - Reduce

extension SearchResultReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    return newState
  }
}
