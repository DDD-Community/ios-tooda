//
//  DiaryImageCellReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit

enum AppError: Error {
  case capturingFailed
}

final class NoteImageCellReactor: Reactor {
  
  let scheduler: Scheduler = MainScheduler.asyncInstance
  
  struct Dependency {
    let factory: NoteImageSectionType
  }
  
  enum Action {
    case initiailizeSection
  }

  enum Mutation {
    case fetchSection([NoteImageSection])
  }

  struct State {
    var sections: [NoteImageSection]
  }

  let initialState: State
  let dependency: Dependency
  
  let disposeBag: DisposeBag = DisposeBag()

  init(dependency: Dependency) {
    self.dependency = dependency
    initialState = State(sections: [])
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .initiailizeSection:
        return .just(Mutation.fetchSection(self.generateSection(images: testNotes)))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
      case .fetchSection(let sections):
        newState.sections = sections
      default:
        break
    }
    
    return newState
  }
  
  private func generateSection(images: [NoteImage]) -> [NoteImageSection] {
    return self.dependency.factory(images)
  }
}

// TODO: 이미지 셀 영역을 위한 코드, 제거 예정
let testNotes: [NoteImage] = [
  .init(id: 0, url: "aaaaaaaaa"),
  .init(id: 1, url: "bbbbbbbbb"),
  .init(id: 2, url: "ccccccccc")
]

typealias NoteImageSectionType = ([NoteImage]) -> [NoteImageSection]

let noteImageSectionFactory: NoteImageSectionType = { images -> [NoteImageSection] in
  var sections: [NoteImageSection] = [
    NoteImageSection.init(identity: .empty, items: []),
    NoteImageSection.init(identity: .item, items: [])
  ]
  
  let emptyReactor: EmptyNoteImageItemCellReactor = EmptyNoteImageItemCellReactor()
  let emptySectionItem: NoteImageSectionItem = NoteImageSectionItem.empty(emptyReactor)
  sections[NoteImageSection.Identity.empty.rawValue].items = [emptySectionItem]
  
  let imageSectionItems = images.map { NoteImageItemCellReactor(item: $0) }.map { NoteImageSectionItem.item($0)}
  sections[NoteImageSection.Identity.item.rawValue].items = imageSectionItems
  
  return sections
}
