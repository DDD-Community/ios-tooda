//
//  EmptyNoteStockCellReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit

final class EmptyNoteStockCellReactor: Reactor {
  enum Action {

  }

  enum Mutation {

  }

  struct State {
    var isEnabled: Bool
  }

  let initialState: State
  private let uuid: String = UUID().uuidString

  init(isEnabled: Bool) {
    initialState = State(isEnabled: isEnabled)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    return .empty()
  }

  func reduce(state: State, mutation: Action) -> State {
    var newState = state
    return newState
  }
}

extension EmptyNoteStockCellReactor: Hashable {
  static func == (lhs: EmptyNoteStockCellReactor, rhs: EmptyNoteStockCellReactor) -> Bool {
    return lhs.uuid == rhs.uuid
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self).hashValue)
  }
}
