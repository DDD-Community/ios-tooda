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
    let authorization: AppAuthorizationType
    let createDiarySectionFactory: CreateNoteSectionType
  }

  enum Action {
    case initializeForm
//    case didSelectedItem(IndexPath)
    case dismissView
    case regist
    case didSelectedImageItem(IndexPath)
  }

  enum Mutation {
    case initializeForm([NoteSection])
    case requestPermissionMessage(String)
    case showAlertMessage(String?)
  }

  struct State {
    var sections: [NoteSection]
    var requestPermissionMessage: String?
    var showAlertMessage: String?
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
    case .didSelectedImageItem(let index):
      return checkAuthorizationAndSelectedItem(indexPath: index)
    default:
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .initializeForm(let sections):
      newState.sections = sections
    case .requestPermissionMessage(let message):
      newState.requestPermissionMessage = message
    case .showAlertMessage(let message):
      newState.showAlertMessage = message
    }

    return newState
  }

  private func makeSections() -> [NoteSection] {
    let sections = self.dependency.createDiarySectionFactory(self.dependency.authorization, self.dependency.coordinator)
    return sections
  }
  
//  private func didSelectedItem(index: IndexPath) {
//    let selectedSection = index.section
//
//    guard let matched = NoteSection.Identity.allCases.first(where: { $0.rawValue == selectedSection }) else { return }
//
//    switch matched {
//      case .content:
//        print("컨텐츠 섹션")
//      case .addStock:
//        print("종목 섹션")
//      case .link:
//        print("링크 섹션")
//      default:
//        return
//    }
//  }
  
  private func didSelectedImageItem(_ indexPath: IndexPath) -> Observable<Mutation> {
    
    let section = self.currentState.sections[NoteSection.Identity.image.rawValue]
    
    guard let imageCellReactor = section.items.compactMap { items -> NoteImageCellReactor? in
      if case let NoteSectionItem.image(value) = items {
        return value
      } else {
        return nil
      }
    }.first else { return .empty() }
    
    let imageItemSection = imageCellReactor.currentState.sections[indexPath.section]
    
    let imageSectionItem = imageItemSection.items[indexPath.row]
    
    switch imageSectionItem {
      case .empty:
        guard imageCellReactor.currentState.sections[NoteImageSection.Identity.item.rawValue].items.count < 3 else {
          print("이미지는 최대 3개까지 등록 가능합니다.")
          return .empty()
        }
        
        print("이미지 등록")
      case .item(let reactor):
        print("이미지 삭제: \(reactor.currentState.item.imageURL)")
    }
    
    return .empty()
  }
  
  private func checkAuthorizationAndSelectedItem(indexPath: IndexPath) -> Observable<Mutation> {
    let service = self.dependency.authorization
    
    return service.photoLibrary.flatMap { [weak self] status -> Observable<Mutation> in
      switch status {
        case .authorized:
          guard let mutation = self?.didSelectedImageItem(indexPath) else { return .empty() }
          return mutation
        default:
          return .just(Mutation.requestPermissionMessage("테스트"))
      }
    }
  }
}

typealias CreateNoteSectionType = (AppAuthorizationType, AppCoordinatorType) -> [NoteSection]

let createDiarySectionFactory: CreateNoteSectionType = { authorization, coordinator -> [NoteSection] in
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
  
  let imageReactor: NoteImageCellReactor = NoteImageCellReactor(dependency: .init(factory: noteImageSectionFactory))
  let imageSectionItem: NoteSectionItem = NoteSectionItem.image(imageReactor)

  sections[NoteSection.Identity.content.rawValue].items = [contentSectionItem]
  sections[NoteSection.Identity.addStock.rawValue].items = [addStockSectionItem]
  sections[NoteSection.Identity.image.rawValue].items = [imageSectionItem]

  return sections
}
