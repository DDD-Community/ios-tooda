//
//  PopUpReactor.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import Then
import RxRelay
import RxCocoa

final class PopUpReactor: Reactor {
  
  // MARK: - Constants
  
  enum PopUpType {
    case list // 아직 모델링 미정
    case textInput(PublishRelay<String>)
  }
  
  // MARK: Reactor
  
  enum Action {
    
  }

  enum Mutation {
    
  }
  
  struct Dependency {
    let type: PopUpType
  }
  
  struct State {
    
  }

  // MARK: Properties
  
  let dependency: Dependency
  
  let initialState: State
  
  init(dependency: Dependency) {
    self.dependency = dependency
    self.initialState = State()
  }
}
