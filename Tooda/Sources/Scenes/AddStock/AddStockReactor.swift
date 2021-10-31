  //
  //  AddStockReactor.swift
  //  Tooda
  //
  //  Created by Lyine on 2021/10/31.
  //  Copyright © 2021 DTS. All rights reserved.
  //

import Foundation

import ReactorKit
import RxSwift
import RxRelay

final class AddStockReactor: Reactor {
  
  // MARK: Reactor
  
  enum Action {
    case searchTextDidChanged(String)
  }
  
  enum Mutation {
    case fetchSearchResultSection([AddStockSection])
  }
  
  struct Dependency {
    let completionRelay: PublishRelay<String>
  }
  
  struct State {
    var sections: [AddStockSection] = [
      .init(identity: .list, items: [])
    ]
  }
  
  init(dependency: Dependency) {
    self.dependency = dependency
    self.initialState = State()
  }
  
    // MARK: Properties
  
  let dependency: Dependency
  
  let initialState: State
}

// MARK: - Extensions

extension AddStockReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .searchTextDidChanged(let keyword):
        print(keyword)
        
        // TODO: Search API dependency 추가
        return .empty()
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
      case .fetchSearchResultSection(let sections):
        state.sections = sections
    }
    
    return state
  }
}
