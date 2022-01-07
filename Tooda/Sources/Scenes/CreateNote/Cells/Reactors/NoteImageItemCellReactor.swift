//
//  NoteImageItemCellReactor.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit

final class NoteImageItemCellReactor: Reactor {
  enum Action {
    
  }
  
  enum Mutation {
    
  }
  
  struct State {
    var item: NoteImage
  }
  
  let initialState: State
  
  init(item: NoteImage) {
    initialState = State(item: item)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    return .empty()
  }
  
  func reduce(state: State, mutation: Action) -> State {
    var newState = state
    return newState
  }
}

// MARK: - Extensions

extension NoteImageItemCellReactor: Hashable {
  static func == (lhs: NoteImageItemCellReactor, rhs: NoteImageItemCellReactor) -> Bool {
    return lhs.currentState.item.id == rhs.currentState.item.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self).hashValue)
  }
}
