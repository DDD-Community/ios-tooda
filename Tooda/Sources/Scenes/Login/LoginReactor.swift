//
//  LoginReactor.swift
//  Tooda
//
//  Created by 황재욱 on 2021/06/12.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class LoginReactor: Reactor {
  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
  }
  
  enum Action {
    
  }
  
  struct State {
    
  }
  
  private let dependency: Dependency
  
  let initialState: State = State()
  
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
}
