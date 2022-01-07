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

  }

  enum Mutation {

  }

  struct State {
    var payload: Payload
  }
  
  struct Payload {
    var name: String
    var rate: Float
  }

  let initialState: State

  init(payload: Payload) {
    initialState = State(payload: payload)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    return .empty()
  }

  func reduce(state: State, mutation: Action) -> State {
    var newState = state
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
    return lhs.currentState.payload.name == rhs.currentState.payload.name &&
    lhs.currentState.payload.rate == rhs.currentState.payload.rate
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self).hashValue)
  }
}
