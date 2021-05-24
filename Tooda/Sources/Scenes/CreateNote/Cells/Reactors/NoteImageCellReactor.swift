//
//  DiaryImageCellReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit

final class NoteImageCellReactor: Reactor {
  
  let scheduler: Scheduler = MainScheduler.asyncInstance
  
  struct Dependency {
    let factory: NoteImageSectionType
  }
  
  enum Action {
    case initiailizeSection
    // TODO: 이미지 추가 로직
//    case addImage
  }

  enum Mutation {
    case fetchSection([NoteImageSection])
//    case addImage([NoteImageSectionItem])
  }

  struct State {
    var sections: [NoteImageSection]
  }

  let initialState: State
  let dependency: Dependency

  init(dependency: Dependency) {
    self.dependency = dependency
    initialState = State(sections: [])
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .initiailizeSection:
        return .just(Mutation.fetchSection(self.generateSection(images: [])))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
      case .fetchSection(let sections):
        newState.sections = sections
        return newState
    }
  }
  
  private func generateSection(images: [NoteImage]) -> [NoteImageSection] {
    return self.dependency.factory(images)
  }
}
