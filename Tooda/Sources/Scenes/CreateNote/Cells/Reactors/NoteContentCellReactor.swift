//
//  DiaryContentCellReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit

final class NoteContentCellReactor: Reactor {

  enum Action {

  }

  enum Mutation {

  }

  struct State {

  }

  let initialState: State
  private let uuid: String = UUID().uuidString

  init() {
    initialState = State()
  }

//	func mutate(action: Action) -> Observable<Mutation> {
//		return .empty()
//	}

  func reduce(state: State, mutation: Action) -> State {
    var newState = state
    return newState
  }

}

// MARK: - Extensions

extension NoteContentCellReactor: Hashable {
  static func == (lhs: NoteContentCellReactor, rhs: NoteContentCellReactor) -> Bool {
    return lhs.uuid == rhs.uuid
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self).hashValue)
  }
}
