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
    case fetchSections
    case addImage(String)
    case removeImage(IndexPath)
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
    initialState = State(sections: dependency.factory([]))
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .fetchSections:
        return self.fetchAlreadyExistSections()
      case .addImage(let url):
        return self.addImageSectionItem(imageURL: url)
      case .removeImage(let index):
        return self.removeImageSectionItems(index)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
      case .fetchSection(let sections):
        newState.sections = sections
    }
    
    return newState
  }
  
  private func generateSection(images: [NoteImage]) -> [NoteImageSection] {
    return self.dependency.factory(images)
  }
  
  private func fetchAlreadyExistSections() -> Observable<Mutation> {
    guard let section = self.currentState.sections[safe: NoteImageSection.Identity.item.rawValue] else {
      return .empty()
    }
    
    let imageItemCellReactors = section.items.compactMap { sectionItems -> NoteImageItemCellReactor? in
      if case let NoteImageSectionItem.item(value) = sectionItems {
        return value
      } else {
        return nil
      }
    }
    
    let images = imageItemCellReactors.map { $0.currentState.item }
    
    let sections = self.dependency.factory(images)
    
    return Observable.just(.fetchSection(sections))
  }
  
  private func addImageSectionItem(imageURL: String) -> Observable<Mutation> {
    // Todo: NoteImage 모델은 상세에서만 쓰일것 같아 ItemReactor 모델 추후변경 예정
    let item = NoteImage.init(id: 0, url: imageURL)
    let reactor = NoteImageItemCellReactor(item: item)
    let sectionItem = NoteImageSectionItem.item(reactor)
    
    var sections = self.currentState.sections
    
    var sectionItems = sections[NoteImageSection.Identity.item.rawValue].items
    
    sectionItems.append(sectionItem)
    
    sections[NoteImageSection.Identity.item.rawValue].items = sectionItems
    
    return .just(.fetchSection(sections))
  }
  
  private func removeImageSectionItems(_ index: IndexPath) -> Observable<Mutation> {
    
    var sections = self.currentState.sections
    
    var sectionItems = sections[NoteImageSection.Identity.item.rawValue].items
    
    sectionItems.remove(at: index.row)
    
    sections[NoteImageSection.Identity.item.rawValue].items = sectionItems
    
    return .just(.fetchSection(sections))
  }
}

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

extension NoteImageCellReactor: Hashable {
  static func == (lhs: NoteImageCellReactor, rhs: NoteImageCellReactor) -> Bool {
    return lhs.currentState.sections == rhs.currentState.sections
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self).hashValue)
  }
}
