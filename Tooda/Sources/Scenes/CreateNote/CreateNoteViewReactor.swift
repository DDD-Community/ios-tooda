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
  
  let scheduler: Scheduler = MainScheduler.asyncInstance

  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
    let authorizationService: AuthorizationServiceType
    let createDiarySectionFactory: CreateNoteSectionType
  }

  enum Action {
    case initializeForm
    case didSelectedItem(IndexPath)
    case dismissView
    case regist
  }

  enum Mutation {
    case initializeForm([NoteSection])
    case didSelectedItem(IndexPath)
  }

  struct State {
    var sections: [NoteSection]
  }

  let initialState: State

  let dependency: Dependency

  init(dependency: Dependency) {
    self.dependency = dependency
    self.initialState = State(sections: [])
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initializeForm:
      return .just(Mutation.initializeForm(makeSections()))
    case .regist:
      return self.createNote()
    default:
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .initializeForm(let sections):
      newState.sections = sections
    default:
      break
    }

    return newState
  }

  private func makeSections() -> [NoteSection] {
    let sections = self.dependency.createDiarySectionFactory(self.dependency.authorizationService, self.dependency.coordinator)
    return sections
  }
  
  
  private func didSelectedItem(index: IndexPath) {
    let selectedSection = index.section
        
    guard let matched = NoteSection.Identity.allCases.first(where: { $0.rawValue == selectedSection }) else { return }
    
    switch matched {
      case .content:
        print("컨텐츠 섹션")
      case .addStock:
        print("종목 섹션")
      case .link:
        print("링크 섹션")
      default:
        return
    }
  }
  
  private func createNote() -> Observable<Mutation> {
    
    let contentTitleReactor = self.currentState.sections[NoteSection.Identity.content.rawValue].items.compactMap { items -> NoteContentCellReactor? in
      if case let NoteSectionItem.content(reactor) = items {
        return reactor
      } else {
        return nil
      }
    }
    
    let stockReactors = self.currentState.sections[NoteSection.Identity.stock.rawValue].items.compactMap { items -> NoteStockCellReactor? in
      if case let NoteSectionItem.stock(reactor) = items {
        return reactor
      } else {
        return nil
      }
    }
    
    let imageReactors = self.currentState.sections[NoteSection.Identity.image.rawValue].items.compactMap { items -> NoteImageCellReactor? in
      if case let NoteSectionItem.image(reactor) = items {
        return reactor
      } else {
        return nil
      }
    }
    
    var noteImageItems: [NoteImage] = []
    if let imageReactor = imageReactors.first {
      let imageItemReactors = imageReactor.currentState.sections[NoteImageSection.Identity.item.rawValue].items.compactMap { items -> NoteImageItemCellReactor? in
        if case let NoteImageSectionItem.item(reactor) = items {
          return reactor
        } else {
          return nil
        }
      }
      
      noteImageItems = imageItemReactors.map { $0.currentState.item }
    }
        
    let linkReactors = self.currentState.sections[NoteSection.Identity.image.rawValue].items.compactMap { items -> NoteLinkCellReactor? in
      if case let NoteSectionItem.link(reactor) = items {
        return reactor
      } else {
        return nil
      }
    }
    
    dump(contentTitleReactor.map { $0.currentState.title } )
    dump(stockReactors)
    dump(noteImageItems)
    dump(linkReactors)
    
    return .empty()
  }
}

typealias CreateNoteSectionType = (AuthorizationServiceType, AppCoordinatorType) -> [NoteSection]

let createDiarySectionFactory: CreateNoteSectionType = { authorizationService, coordinator -> [NoteSection] in
  var sections: [NoteSection] = [
    NoteSection(identity: .content, items: []),
    NoteSection(identity: .stock, items: []),
    NoteSection(identity: .addStock, items: []),
    NoteSection(identity: .image, items: []),
    NoteSection(identity: .link, items: [])
  ]

  let contentReactor: NoteContentCellReactor = NoteContentCellReactor()
  let contentSectionItem: NoteSectionItem = NoteSectionItem.content(contentReactor)
  
  let addStockReactor: EmptyNoteStockCellReactor = EmptyNoteStockCellReactor()
  let addStockSectionItem: NoteSectionItem = NoteSectionItem.addStock(addStockReactor)
  
  let imageReactor: NoteImageCellReactor = NoteImageCellReactor(dependency: .init(factory: noteImageSectionFactory,
                                                                                  authorizationService: authorizationService,
                                                                                  coordinator: coordinator))
  let imageSectionItem: NoteSectionItem = NoteSectionItem.image(imageReactor)

  sections[NoteSection.Identity.content.rawValue].items = [contentSectionItem]
  sections[NoteSection.Identity.addStock.rawValue].items = [addStockSectionItem]
  sections[NoteSection.Identity.image.rawValue].items = [imageSectionItem]

  return sections
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
