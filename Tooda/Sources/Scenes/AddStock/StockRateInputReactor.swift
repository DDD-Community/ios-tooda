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
  var name: String { get }
  var coordinator: AppCoordinatorType { get }
  var completion: PublishRelay<NoteStock> { get }
}

final class StockRateInputReactor: Reactor {
  enum Action {
    case closeButtonDidTapped
  }
  
  enum Mutation {
    
  }
  
  struct State {
    
  }
  
  struct Dependency: StockRateInputDependencyType {
    var name: String
    var completion: PublishRelay<NoteStock>
    var coordinator: AppCoordinatorType
  }
  
  let initialState: State
  let dependency: StockRateInputDependencyType
  
  init(dependency: StockRateInputDependencyType) {
    self.dependency = dependency
    initialState = State()
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .closeButtonDidTapped:
        return self.closeButtonDidTapped()
    }
  }
  
  func reduce(state: State, mutation: Action) -> State {
    var newState = state
    return newState
  }
}

// MARK: - Extensions

extension StockRateInputReactor {
  private func closeButtonDidTapped() -> Observable<Mutation> {
    self.dependency.coordinator.close(style: .pop, animated: true, completion: nil)
    
    return .empty()
  }
}
