//
//  SearchRecentReactor.swift
//  Tooda
//
//  Created by jinsu on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class SearchRecentReactor: Reactor {

  // MARK: Dependency

  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
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

extension SearchRecentReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    return Observable<Mutation>.empty()
  }
}


// MARK: - Reduce

extension SearchRecentReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    return state
  }
}
