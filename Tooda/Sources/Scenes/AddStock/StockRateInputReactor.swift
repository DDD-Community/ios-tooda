//
//  StockRateInputReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxCocoa
import ReactorKit

final class StockRateInputReactor: Reactor {
  enum Action {
    case closeButtonDidTapped
    case selectedStockDidChanged(StockChangeState)
  }
  
  enum Mutation {
    case selectedRateDidChanged(StockChangeState)
  }
  
  struct State {
    var selectedRate: StockChangeState?
  }
  
  struct Payload {
    var name: String
    var completion: PublishRelay<NoteStock>
  }
  
  struct Dependency {
    var coordinator: AppCoordinatorType
  }
  
  let initialState: State
  let dependency: Dependency
  private var payload: Payload
  
  init(
    dependency: Dependency,
    payload: Payload
  ) {
    self.dependency = dependency
    self.payload = payload
    initialState = State()
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .closeButtonDidTapped:
        return self.closeButtonDidTapped()
      case .selectedStockDidChanged(let rate):
        return self.selectedStockDidChanged(rate)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
      case .selectedRateDidChanged(let rate):
        newState.selectedRate = rate
    }
    
    return newState
  }
}

// MARK: - Extensions

extension StockRateInputReactor {
  private func closeButtonDidTapped() -> Observable<Mutation> {
    self.dependency.coordinator.close(style: .pop, animated: true, completion: nil)
    
    return .empty()
  }
  
  private func selectedStockDidChanged(_ state: StockChangeState) -> Observable<Mutation> {
    return .just(.selectedRateDidChanged(state))
  }
}
