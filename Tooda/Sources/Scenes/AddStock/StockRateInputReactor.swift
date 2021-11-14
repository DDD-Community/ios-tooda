//
//  StockRateInputReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit

  // Reactor

final class StockRateInputReactor: Reactor {
  enum Action {
    
  }
  
  enum Mutation {
    
  }
  
  struct State {
    
  }
  
  let initialState: State
  
  init() {
    initialState = State()
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    return .empty()
  }
  
  func reduce(state: State, mutation: Action) -> State {
    var newState = state
    return newState
  }
}
