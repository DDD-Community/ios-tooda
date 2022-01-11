//
//  DiaryStockCellReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit

final class NoteStockCellReactor: Reactor {
  enum Action {
    case payloadDidChanged(NoteStock)
  }

  enum Mutation {
    case payloadDidChanged(NoteStock)
  }

  struct State {
    var payload: Payload
  }
  
  struct Payload {
    var name: String
    var rate: Float
  }

  let initialState: State
  
  private let uuid: String = UUID().uuidString

  init(payload: Payload) {
    initialState = State(payload: payload)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    
    switch action {
      case .payloadDidChanged(let stock):
        return .just(.payloadDidChanged(stock))
    }
    
    return .empty()
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
      case .payloadDidChanged(let stock):
        newState.payload.name = stock.name
        newState.payload.rate = stock.changeRate ?? 0.0
    }
    
    return newState
  }
}

  // MARK: Extensions

extension NoteStockCellReactor.Payload {
  var state: StockChangeState {
    let value = self.rate
    
    switch value {
      case let _ where value > 0:
        return .rise
      case let _ where value == 0:
        return .even
      default:
        return .fall
    }
  }
}

extension NoteStockCellReactor: Hashable {
  static func == (lhs: NoteStockCellReactor, rhs: NoteStockCellReactor) -> Bool {
    return lhs.uuid == rhs.uuid
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self).hashValue)
  }
}
