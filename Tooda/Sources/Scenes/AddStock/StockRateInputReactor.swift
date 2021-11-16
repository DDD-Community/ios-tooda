//
//  StockRateInputReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxCocoa
import ReactorKit

protocol StockRateInputDependencyType {
  var stock: Stock { get }
  var completion: PublishRelay<NoteStock> { get }
}

final class StockRateInputReactor: Reactor {
  enum Action {
    
  }
  
  enum Mutation {
    
  }
  
  struct State {
    
  }
  
  struct Dependency: StockRateInputDependencyType {
    var stock: Stock
    var completion: PublishRelay<NoteStock>
  }
  
  let initialState: State
  let dependency: StockRateInputDependencyType
  
  init(dependency: StockRateInputDependencyType) {
    self.dependency = dependency
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
