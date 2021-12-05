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
