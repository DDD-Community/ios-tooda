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
    var title: String
    var content: String
  }

  let initialState: State

  init() {
    // TODO: 데이터 테스트용, 변경 예정
    initialState = State(title: "aaa", content: "bbb")
  }

//	func mutate(action: Action) -> Observable<Mutation> {
//		return .empty()
//	}

  func reduce(state: State, mutation: Action) -> State {
    var newState = state
    return newState
  }

}
