//
//  StockItemCellReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/10/31.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit
import RxSwift

final class StockItemCellReactor: Reactor {
  
  struct Depdendency {
    
  }
  
    // MARK: Reactor
  
  enum Action {
    
  }
  
  enum Mutation {
    
  }
  
  struct Dependency {
    
  }
  
  struct State {
    
  }
  
  init(dependency: Dependency) {
    self.dependency = dependency
    self.initialState = State()
  }
  
    // MARK: Properties
  
  let dependency: Dependency
  
  let initialState: State
}
