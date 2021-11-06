//
//  SearchReactor.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/10/25.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class SearchReactor: Reactor {

  // MARK: Dependency

  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
  }


  // MARK: Reactor

  enum Action {
    case back
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

extension SearchReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .back:
      self.dependency.coordinator.close(
        style: .pop,
        animated: true,
        completion: nil
      )
      return Observable<Mutation>.empty()
    }
  }

}


// MARK: - Reduce

extension SearchReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    return state
  }
}
