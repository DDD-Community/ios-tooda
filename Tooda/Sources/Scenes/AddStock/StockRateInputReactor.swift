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
    case backbuttonDidTapped
    case closeButtonDidTapped
    case selectedStockDidChanged(StockChangeState)
    case textFieldDidChanged(Float?)
    case addButtonDidTapped
  }
  
  enum Mutation {
    case selectedRateDidChanged(StockChangeState)
    case addButtonDidChanged(Bool)
    case rateDidChanged(Float?)
  }
  
  struct State {
    var name: String
    var selectedRate: StockChangeState = .EVEN
    var rateInput: Float?
    var buttonDidChanged: Bool = true
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
      case .backbuttonDidTapped:
        return self.viewDidPop()
      case .selectedStockDidChanged(let rate):
        return self.selectedStockDidChanged(rate)
      case .textFieldDidChanged(let rate):
        return self.textFieldDidChanged(rate)
      case .addButtonDidTapped:
        return .concat([self.addButtonDidTapped(), self.viewDidDismiss()])
      case .closeButtonDidTapped:
        return self.viewDidDismiss()
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
  private func viewDidPop() -> Observable<Mutation> {
    self.dependency.coordinator.close(style: .pop, animated: true, completion: nil)
    
    return .empty()
  }
  
  private func viewDidDismiss() -> Observable<Mutation> {
    self.dependency.coordinator.close(style: .dismiss, animated: true, completion: nil)
    
    return .empty()
  }
  
  private func selectedStockDidChanged(_ state: StockChangeState) -> Observable<Mutation> {
    
    switch state {
      case .RISE, .FALL:
        let addButtonEnabled = self.currentState.rateInput != nil
        return .concat([.just(.selectedRateDidChanged(state)), .just(.addButtonDidChanged(addButtonEnabled))])
      case .EVEN:
        return .concat([.just(.selectedRateDidChanged(state)), .just(.addButtonDidChanged(true))])
    }
  }
  
  private func textFieldDidChanged(_ rate: Float?) -> Observable<Mutation> {
    
    let buttonDidEnabled = rate != nil
    
    return .concat([.just(.rateDidChanged(rate)), .just(.addButtonDidChanged(buttonDidEnabled))])
  }
  
  private func addButtonDidTapped() -> Observable<Mutation> {
    
    let changeRate = self.generateRateMutifiler() * (self.currentState.rateInput ?? 0.0)
    
    let noteStock = NoteStock(id: 0,
                                   name: self.currentState.name,
                                   change: self.currentState.selectedRate,
                                   changeRate: changeRate)
    
    self.payload.completion.accept(noteStock)
    
    return .empty()
  }
  
  private func generateRateMutifiler() -> Float {
    switch self.currentState.selectedRate {
      case .EVEN, .RISE:
        return 1
      case .FALL:
        return -1
    }
  }
}
