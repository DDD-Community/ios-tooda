//
//  CreateNoteViewReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation
import ReactorKit

final class CreateNoteViewReactor: Reactor {

  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
  }

  enum Action {
    case initializeForm
    case dismissView
    case regist
  }

  enum Mutation {
    case initializeForm([NoteSection])
  }

  struct State {
    var sections: [NoteSection]
  }

  let initialState: State

  let dependency: Dependency
  let createDiarySectionFactory: CreateNoteSectionType

  init(createDiarySectionFactory: @escaping CreateNoteSectionType,
       dependency: Dependency) {
    self.initialState = State(sections: [])
    self.createDiarySectionFactory = createDiarySectionFactory
    self.dependency = dependency
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initializeForm:
      return .just(Mutation.initializeForm(makeSections()))
    default:
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .initializeForm(let sections):
      newState.sections = sections
    }

    return newState
  }

  private func makeSections() -> [NoteSection] {
    let sections = self.createDiarySectionFactory()
    return sections
  }
}

typealias CreateNoteSectionType = () -> [NoteSection]

let createDiarySectionFactory: CreateNoteSectionType = {
  var sections: [NoteSection] = [
    NoteSection(identity: .content, items: []),
    NoteSection(identity: .addStock, items: []),
    NoteSection(identity: .image, items: [])
  ]

  let contentReactor: NoteContentCellReactor = NoteContentCellReactor()
  let contentSectionItem: NoteSectionItem = NoteSectionItem.content(contentReactor)

  sections[NoteSection.Identity.content.rawValue].items = [contentSectionItem]

  return sections
}
