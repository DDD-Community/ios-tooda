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
    case textFieldDidChanged(Float?)
  }
  
  enum Mutation {
    case selectedRateDidChanged(StockChangeState)
    case addButtonDidChanged(Bool)
    case rateDidChanged(Float)
  }
  
  struct State {
    var name: String
    var selectedRate: StockChangeState = .EVEN
    var rateInput: Float = 0.0
    var buttonDidChanged: Bool = false
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
    initialState = State(name: payload.name)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .closeButtonDidTapped:
        return self.closeButtonDidTapped()
      case .selectedStockDidChanged(let rate):
        return self.selectedStockDidChanged(rate)
      case .textFieldDidChanged(let rate):
        return self.textFieldDidChanged(rate)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
      case .selectedRateDidChanged(let rate):
        newState.selectedRate = rate
      case .addButtonDidChanged(let enabled):
        newState.buttonDidChanged = enabled
      case .rateDidChanged(let rate):
        newState.rateInput = rate
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
    return .concat([.just(.selectedRateDidChanged(state)), .just(.addButtonDidChanged(state == .EVEN))])
  }
  
  private func textFieldDidChanged(_ rate: Float?) -> Observable<Mutation> {
    
    let buttonDidEnabled = rate != nil
    
    guard let rateValue = rate else {
      return .just(.addButtonDidChanged(buttonDidEnabled))
    }
    
    return .concat([.just(.rateDidChanged(rateValue)), .just(.addButtonDidChanged(buttonDidEnabled))])
  }
}
