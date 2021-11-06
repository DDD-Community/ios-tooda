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
    
  }
  
  enum Mutation {
    
  }
  
  struct Dependency {
    let completionRelay: PublishRelay<String>
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
