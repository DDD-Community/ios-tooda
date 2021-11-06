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
  
  // MARK: Reactor
  
  enum Action {
    
  }
  
  enum Mutation {
    
  }
  
  struct Dependency {
    var id: Int
    var name: String
  }
  
  struct State {
    var name: String
  }
  
  init(dependency: Dependency) {
    self.dependency = dependency
    self.initialState = State(name: dependency.name)
  }
  
    // MARK: Properties
  
  let dependency: Dependency
  
  let initialState: State
}
