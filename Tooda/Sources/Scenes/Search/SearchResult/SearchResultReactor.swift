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
    let networking: NetworkingProtocol
  }


  // MARK: Reactor

  enum Action {
    case search(text: String)
  }

  enum Mutation {
    case setNotes([Note])
  }

  struct State {
    var notes: [Note]
  }


  // MARK: Properties

  private let dependency: Dependency

  let initialState: State = State(notes: [])

  init(dependency: Dependency) {
    self.dependency = dependency
  }
}


// MARK: - Mutate

extension SearchResultReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .search(text):
      return .empty()
    }
  }
}


// MARK: - Reduce

extension SearchResultReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setNotes(notes):
      newState.notes = notes
    }

    return newState
  }
}
